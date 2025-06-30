using System;
using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.Gameplay;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using FsmAsync;
using UnityEngine;
using User.States;

namespace User
{
    public class PlayerController : MonoBehaviour, ISetup<IPhysicsCharacter<ReverseIndexStore>>
    {
        [Flags]
        private enum LogIfError
        {
            None = 0,
            Move = 1,
            Jump = 2,
            Fall = 4,
            Land = 8,
            Glide = 16,
        }
        [Tooltip("If true, this component will try to do an auto-setup." +
                 "\nUseful for editor testing.")]
        [field: SerializeField] public bool SelfSetupCharacter { get; set; }

        [SerializeField] private LogIfError inputsToLogIfTransitionFails;

        [Header("Providers")]
        [SerializeField] private InterfaceRef<IDataProviderAsync<IInputReader>> inputReaderProvider;
        
        [SerializeField] private float fallingGravityMultiplier = 2.5f;
        
        [Header("States")]
        [SerializeField] private bool logFsmTransitions = false;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> idle;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> walk;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> jump;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> fall;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> glide;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> walkWhileFalling;
        
        [Header("Ids")]
        [SerializeField] private IdContainer characterId;
        [SerializeField] private InterfaceRef<IIdentifier> actorId;
        [SerializeField] private InterfaceRef<IIdentifier> traversalInputId;
        
        [SerializeField] private IdContainer stopId;
        [SerializeField] private IdContainer moveId;
        [SerializeField] private IdContainer jumpId;
        [SerializeField] private IdContainer fallId;
        [SerializeField] private IdContainer landId;
        [SerializeField] private IdContainer lastInputId;
        [SerializeField] private InterfaceRef<IIdentifier> glideId;
        
        [SerializeField] private float secondsBeforeGlide = 1;
        
        private IPhysicsCharacter<ReverseIndexStore> _character;
        private Vector2 _lastInput;
        private float _directionMagnitude;
        private Coroutine _enableCoroutine;
        
        private FiniteStateMachine<IIdentifier, IActor<ReverseIndexStore>> _fsm;
        private AutoMap<Texture2D> BlackTexture = new(() => new Texture2D(1, 1));
        private StateDelayedHandler<IActor<ReverseIndexStore>> _glideDelay;

        public IActor<ReverseIndexStore> Actor => _character.Actor;

        private async void OnEnable()
        {
            if (inputReaderProvider.Ref == null)
            {
                Debug.LogError($"{name} <color=grey>({nameof(PlayerController)})</color>: {nameof(inputReaderProvider)} is null!");
                return;
            }
            var inputReader = await inputReaderProvider.Ref.GetValueAsync(destroyCancellationToken);
            inputReader.OnMoveInput += HandleMoveInput;
            inputReader.OnJumpPressed += StartJump;
        }

        private void Start()
        {
            if (SelfSetupCharacter)
            {
                if (!TryGetComponent(out _character))
                {
                    Debug.LogError($"{tag}: No character component found!", this);
                    return;
                }

                if (_character is ISetup<ReverseIndexStore> setupable)
                    setupable.Setup(new ReverseIndexStore());
                var views = GetComponentsInChildren<ISetup<ICharacter>>();
                foreach (var view in views)
                    view.Setup(_character);
            }
            if (_character != null)
                Setup(_character);
        }

        private void OnDisable()
        {
            _enableCoroutine.TryStop(this);
            if (inputReaderProvider.Ref.TryGetValue(out var inputReader))
            {
                inputReader.OnMoveInput -= HandleMoveInput;
                inputReader.OnJumpPressed -= StartJump;
            }

            _fsm?.End(Actor, destroyCancellationToken).Forget();
        }

        public void Setup(IPhysicsCharacter<ReverseIndexStore> data)
        {
            _character = data;
            Actor.Data.Add(characterId.Get, _character);
            Actor.Data.Add(actorId.Ref, _character.Actor);
            Actor.Data.Add(traversalInputId.Ref, Vector2.zero);
            _character.FallingController.OnStartFalling += AddGravity;
            _character.FallingController.OnStopFalling += RestoreGravity;
            SetupFsm(_character);
        }

        private async void SetupFsm(IPhysicsCharacter character)
        {
            //THOUGHT: These states should be loaded from a file in the future. And that file should be created from the FSM Editor
            var floorTracker = character?.FloorTracker;
            if (floorTracker == null)
            {
                Debug.LogError($"{name}: {nameof(floorTracker)} component was not found in character!");
                return;
            }
            idle.Ref.Logger = Debug.unityLogger;
            
            walk.Ref.Logger = Debug.unityLogger;
            
            walkWhileFalling.Ref.Logger = Debug.unityLogger;
            
            jump.Ref.Logger = Debug.unityLogger;
            
            _glideDelay = new StateDelayedHandler<IActor<ReverseIndexStore>>(secondsBeforeGlide, TransitionToGlide);
            jump.Ref.OnEnter.Add(_glideDelay.Handle);
            walk.Ref.OnEnter.Add(_glideDelay.Cancel);
            idle.Ref.OnEnter.Add(_glideDelay.Cancel);
            
            fall.Ref.Logger = Debug.unityLogger;
            
            glide.Ref.Logger = Debug.unityLogger;
            
            _fsm = FiniteStateMachine<IIdentifier, IActor<ReverseIndexStore>>
                   .Build(name)
                   .ThatLogsTransitions(Debug.unityLogger, logFsmTransitions)
                   .ThatTransitionsBetween(stopId.Get, walk.Ref, idle.Ref)
                   .ThatTransitionsBetween(stopId.Get, walkWhileFalling.Ref, fall.Ref)
                   .ThatTransitionsBetween(stopId.Get, jump.Ref, fall.Ref)
                   .ThatTransitionsBetween(moveId.Get, idle.Ref, walk.Ref)
                   .ThatTransitionsBetween(moveId.Get, fall.Ref, walkWhileFalling.Ref)
                   .ThatTransitionsBetween(jumpId.Get, idle.Ref, jump.Ref)
                   .ThatTransitionsBetween(jumpId.Get, walk.Ref, jump.Ref)
                   .ThatTransitionsBetween(fallId.Get, idle.Ref, fall.Ref)
                   .ThatTransitionsBetween(fallId.Get, walk.Ref, fall.Ref)
                   .ThatTransitionsBetween(fallId.Get, jump.Ref, fall.Ref)
                   .ThatTransitionsBetween(landId.Get, fall.Ref, idle.Ref)
                   .ThatTransitionsBetween(landId.Get, walkWhileFalling.Ref, walk.Ref)
                   .ThatTransitionsBetween(landId.Get, glide.Ref, walk.Ref)
                   .ThatTransitionsBetween(glideId.Ref, fall.Ref, glide.Ref)
                   .ThatTransitionsBetween(glideId.Ref, walkWhileFalling.Ref, glide.Ref)
                   .ThatTransitionsBetween(glideId.Ref, jump.Ref, glide.Ref)
                   .Done();
            await _fsm.Start(idle.Ref, Actor, destroyCancellationToken);
            
            var fallingController = character?.FallingController;
            if (fallingController == null)
            {
                Debug.LogError($"{name}: {nameof(fallingController)} component was not found in character!");
                return;
            }

            fallingController.OnStartFalling += () => HandleDataChanged(fallId.Get).Forget();
        }
        
        private UniTask HandleDataChanged(IIdentifier data)
        {
            return _character.Actor.Act(_fsm.HandleDataChanged,
                                        Actor,
                                        destroyCancellationToken,
                                        data);
        }

        private void AddGravity()
            => _character?.TryAddContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));

        private void RestoreGravity()
            => _character.RemoveContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));

        private async void TransitionToGlide(IActor<ReverseIndexStore> _)
        {
            Debug.Log("transitioning".Colored(C.Red));
            HandleDataChanged(glideId.Ref).Forget();
            Debug.Log("transitioned".Colored(C.Green));
        }

        private void StartJump()
        {
            HandleDataChanged(jumpId.Get).Forget();
        }

        private async void HandleMoveInput(Vector2 input)
        {
            _lastInput = input;
            _directionMagnitude = input.magnitude;
            if(_character == null)
                return;
            //THOUGHT: Should there be a Condition SO that receives an Input and returns an ID so this logic is done by that structure?
            var stateId = input.magnitude > 0.001f ? moveId : stopId;

            Actor.Data[typeof(Vector2), traversalInputId.Ref] = input;
            
            await HandleDataChanged(stateId.Get);
        }

        private void OnCollisionEnter(Collision collision)
        {
            //THOUGHT: Quick impl for landing, not final
            if (Vector3.Angle(Vector3.up, collision.contacts[0].normal) < 45)
                HandleDataChanged(landId.Get).Forget();
        }

        private void OnGUI()
        {
#if UNITY_EDITOR && ENABLE_UI
            Rect rect = new Rect(10, 50, 300, 150);
            Color textureColor = new Color(0, 0, 0, .75f);

            BlackTexture.Value.SetPixel(0, 0, textureColor);
            BlackTexture.Value.Apply();
            GUI.Box(rect, BlackTexture, GUIStyle.none);
            GUI.DrawTexture(rect, BlackTexture);
            GUILayout.BeginArea(rect);
            GUI.skin.label.fontSize = 15;
            GUI.skin.label.normal.textColor = Color.cyan;
            GUILayout.Label($"State : {_fsm?.Current?.Name}");
            // GUILayout.Label($"Move input : {_lastInput} ({_lastInput.magnitude:f2})");
            var speed = _character?.Velocity.IgnoreY().magnitude;
            GUILayout.Label($"{1.0f * speed}");
            var goalSpeed = _character?.Movement?.goalSpeed;
            GUILayout.Label($"{100.0f * speed / goalSpeed:f2}%");
            GUILayout.Label($"Velocity : {_character?.Velocity}");
            GUILayout.EndArea();
#endif
        }
    }

    public readonly struct StateDelayedHandler<T>
    {
        public float Seconds { get; }
        public CancellationTokenSource TokenSource { get; }
        private readonly Action<T> _onFinished;

        public StateDelayedHandler(float seconds,
                                   Action<T> onFinished)
        {
            Seconds = seconds;
            _onFinished = onFinished;
            TokenSource = new CancellationTokenSource();
        }

        public UniTask Handle(IState<T> state, T data, CancellationToken token)
        {
            Start(data, token).Forget();
            return UniTask.CompletedTask;
        }

        public UniTask Cancel(IState<T> state, T data, CancellationToken token)
        {
            TokenSource.Cancel();
            Debug.Log("Canceled");
            return UniTask.CompletedTask;
        }

        private async UniTaskVoid Start(T data, CancellationToken token)
        {
            Debug.Log("Started");
            var linkedToken = CancellationTokenSource.CreateLinkedTokenSource(token, TokenSource.Token).Token;
            await UniTask.WaitForSeconds(Seconds, cancellationToken: linkedToken);
            Debug.Log("help");
            _onFinished(data);
        }
    }
}