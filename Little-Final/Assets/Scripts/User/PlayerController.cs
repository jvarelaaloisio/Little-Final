using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
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
    public class PlayerController : MonoBehaviour, ISetup<PhysicsCharacter>
    {
        [Header("Providers")]
        [SerializeField] private InterfaceRef<IDataProviderAsync<IInputReader>> inputReaderProvider;
        
        [SerializeField] private float fallingGravityMultiplier = 2.5f;
        
        [Header("States")]
        [SerializeField] private InterfaceRef<ICharacterState> idle;
        [SerializeField] private InterfaceRef<ICharacterState> walk;
        [SerializeField] private InterfaceRef<ICharacterState> jump;
        [SerializeField] private InterfaceRef<ICharacterState> fall;
        [SerializeField] private InterfaceRef<ICharacterState> glide;
        [SerializeField] private InterfaceRef<ICharacterState> walkWhileFalling;
        
        [Header("Ids")]
        [SerializeField] private InterfaceRef<IIdentification> characterId;
        [SerializeField] private InterfaceRef<IIdentification> actorId;
        [SerializeField] private InterfaceRef<IIdentification> traversalInputId;
        
        [SerializeField] private IdContainer stopId;
        [SerializeField] private IdContainer moveId;
        [SerializeField] private IdContainer jumpId;
        [SerializeField] private IdContainer fallId;
        [SerializeField] private IdContainer landId;
        [SerializeField] private IdContainer lastInputId;
        [SerializeField] private InterfaceRef<IIdentification> glideId;
        
        [SerializeField] private float secondsBeforeGlide = 1;
        
        private PhysicsCharacter _character;
        private Vector2 _lastInput;
        private float _directionMagnitude;
        private Coroutine _enableCoroutine;
        
        private FiniteStateMachine<IIdentification> _fsm;
        private AutoMap<Texture2D> BlackTexture = new(() => new Texture2D(1, 1));
        private StateDelayedHandler _glideDelay;

        public IActor<IDictionary<Type, IDictionary<IIdentification, object>>> Actor => _character.Actor;

        private void Start()
        {
            if (_character)
                Setup(_character);
        }

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

        private void OnDisable()
        {
            _enableCoroutine.TryStop(this);
            if (inputReaderProvider.Ref.TryGetValue(out var inputReader))
            {
                inputReader.OnMoveInput -= HandleMoveInput;
                inputReader.OnJumpPressed -= StartJump;
            }

            _fsm?.Current?.Exit(Actor.Data, destroyCancellationToken).Forget();
        }

        public void Setup(PhysicsCharacter data)
        {
            _character = data;
            _character.Actor.Data.Add(typeof(ICharacter), new Dictionary<IIdentification, object>{ { characterId.Ref, _character }});
            _character.Actor.Data.Add(typeof(IPhysicsCharacter), new Dictionary<IIdentification, object>{ { characterId.Ref, _character }});
            _character.Actor.Data.Add(typeof(IActor), new Dictionary<IIdentification, object>{ { actorId.Ref, _character.Actor }});
            _character.Actor.Data.Add(typeof(IActor<IDictionary<Type, IDictionary<IIdentification, object>>>), new Dictionary<IIdentification, object>{ { actorId.Ref, _character.Actor }});
            if (!Actor.Data.TryAdd(typeof(Vector2), new Dictionary<IIdentification, object>{{traversalInputId.Ref, Vector2.zero}}))
                if (!Actor.Data[typeof(Vector2)].TryAdd(traversalInputId.Ref, Vector2.zero))
                    Actor.Data[typeof(Vector2)][traversalInputId.Ref] = Vector2.zero;
            _character.FallingController.OnStartFalling += AddGravity;
            _character.FallingController.OnStopFalling += RestoreGravity;
            SetupFsm(_character);
        }

        private async void SetupFsm(PhysicsCharacter character)
        {
            //THOUGHT: These states should be loaded from a file in the future. And that file should be created from the FSM Editor
            if (!character.TryGetComponent(out IFloorTracker floorTracker))
            {
                Debug.LogError($"{name}: {nameof(floorTracker)} component was not found in character!");
                return;
            }
            idle.Ref.Character = character;
            idle.Ref.Logger = Debug.unityLogger;
            
            walk.Ref.Character = character;
            walk.Ref.Logger = Debug.unityLogger;
            
            walkWhileFalling.Ref.Character = character;
            walkWhileFalling.Ref.Logger = Debug.unityLogger;
            
            jump.Ref.Character = character;
            jump.Ref.Logger = Debug.unityLogger;
            _glideDelay = new StateDelayedHandler(secondsBeforeGlide, TransitionToGlide);
            jump.Ref.OnEnter.Add(_glideDelay.Handle);
            walk.Ref.OnEnter.Add(_glideDelay.Cancel);
            idle.Ref.OnEnter.Add(_glideDelay.Cancel);
            
            fall.Ref.Character = character;
            fall.Ref.Logger = Debug.unityLogger;
            
            glide.Ref.Character = character;
            glide.Ref.Logger = Debug.unityLogger;
            
            _fsm = FiniteStateMachine<IIdentification>.Build(name)
                                                      .ThatLogsTransitions(Debug.unityLogger)
                                                      
                                                      .ThatTransitionsBetween(stopId.Get, walk.Ref, idle.Ref)
                                                      .ThatTransitionsBetween(stopId.Get, walkWhileFalling.Ref, fall.Ref)
                                                      .ThatTransitionsBetween(stopId.Get, jump.Ref, fall.Ref)
                                                      
                                                      .ThatTransitionsBetween(moveId.Get, idle.Ref, walk.Ref)
                                                      .ThatTransitionsBetween(moveId.Get, fall.Ref, walkWhileFalling.Ref)
                                                      //.ThatTransitionsBetween(moveId.Get, jump.Ref, walkWhileFalling.Ref)
                                                      
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
            await _fsm.Start(idle.Ref, Actor.Data, destroyCancellationToken);
        }

        private void Update()
        {
            if (_character?.rigidbody?.velocity.y < 0)
            {
                _character.Actor.Act((_, data, token) => _fsm.HandleInput(data, token, Actor.Data),
                                     fallId.Get,
                                     destroyCancellationToken,
                                     fallId.Get).Forget();
            }
        }

        private void AddGravity()
            => _character?.TryAddContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));

        private void RestoreGravity()
            => _character.RemoveContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));

        private async void TransitionToGlide(IState _)
        {
            Debug.Log("transitioning".Colored(C.Red));
            await _fsm.TryTransitionTo(glideId.Ref, destroyCancellationToken);
            Debug.Log("transitioned".Colored(C.Green));
        }

        private void StartJump()
        {
            // _fsm.TryTransitionTo(jumpId.Get, destroyCancellationToken, new Hashtable()).Forget();
            
            _character.Actor.Act((_, data, token) => _fsm.HandleInput(data, token, Actor.Data),
                                 jumpId.Get,
                                 destroyCancellationToken,
                                 jumpId.Get).Forget();
        }

        private async void HandleMoveInput(Vector2 input)
        {
            _lastInput = input;
            _directionMagnitude = input.magnitude;
            if(!_character)
                return;
            //THOUGHT: Should there be a Condition SO that receives an Input and returns an ID so this logic is done by that structure?
            var stateId = input.magnitude > 0.001f ? moveId : stopId;

            Actor.Data[typeof(Vector2)][traversalInputId.Ref] = input;
            
            //await _fsm.TryTransitionTo(stateId.Get, destroyCancellationToken, data);
            await _character.Actor.Act((_, data, token) => _fsm.HandleInput(data, token, Actor.Data),
                                       stateId.Get,
                                       destroyCancellationToken,
                                       stateId.Get);
        }

        private void OnCollisionEnter(Collision collision)
        {
            //THOUGHT: Quick impl for landing, not final
            if (Vector3.Angle(Vector3.up, collision.contacts[0].normal) < 45)
                _character?.Actor?.Act((_, data, token) => _fsm.HandleInput(data, token, Actor.Data),
                                     landId.Get,
                                     destroyCancellationToken,
                                     landId.Get).Forget();
                //_fsm.TryTransitionTo(landId.Get, destroyCancellationToken, new Hashtable()).Forget();
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
            //GUILayout.Label($"Move input : {_lastInput}");
            var speed = _character?.Velocity.IgnoreY().magnitude;
            var goalSpeed = _character?.Movement?.goalSpeed;
            GUILayout.Label($"{1.0f * speed / goalSpeed:f2}");
            //GUILayout.Label($"Velocity   : {GetComponent<Rigidbody>().velocity}");
            GUILayout.EndArea();
#endif
        }
    }

    public readonly struct StateDelayedHandler
    {
        public float Seconds { get; }
        public CancellationTokenSource TokenSource { get; }
        private readonly Action<IState> _onFinished;

        public StateDelayedHandler(float seconds,
                                   Action<IState> onFinished)
        {
            Seconds = seconds;
            _onFinished = onFinished;
            TokenSource = new CancellationTokenSource();
        }

        public UniTask Handle(IState state, IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
        {
            Start(state, token).Forget();
            return UniTask.CompletedTask;
        }

        public UniTask Cancel(IState state, IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
        {
            TokenSource.Cancel();
            Debug.Log("Canceled");
            return UniTask.CompletedTask;
        }

        private async UniTaskVoid Start(IState state, CancellationToken token)
        {
            Debug.Log("Started");
            var linkedToken = CancellationTokenSource.CreateLinkedTokenSource(token, TokenSource.Token).Token;
            await UniTask.WaitForSeconds(Seconds, cancellationToken: linkedToken);
            Debug.Log("help");
            _onFinished(state);
        }
    }
}