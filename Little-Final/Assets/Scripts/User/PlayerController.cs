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
using FsmAsync.Conditional;
using UnityEngine;

namespace User
{
    public class PlayerController : MonoBehaviour, ISetup<IPhysicsCharacter<ReverseIndexStore>>
    {
        [Tooltip("If true, this component will try to do an auto-setup." +
                 "\nUseful for editor testing.")]
        [field: SerializeField] public bool SelfSetupCharacter { get; set; }
        [SerializeField] private bool enableLog;

        [Header("Providers")]
        [SerializeField] private InterfaceRef<IDataProviderAsync<IInputReader>> inputReaderProvider;

        [Header("States")]
        [SerializeField] private bool enableStateLogs = false;
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
        private Coroutine _enableCoroutine;

        private ConditionalStateMachine<IActor<ReverseIndexStore>, IIdentifier> _fsm;
        private AutoMap<Texture2D> BlackTexture = new(() => new Texture2D(1, 1));
        private StateDelayedHandler<IActor<ReverseIndexStore>> _glideDelay;

        private UniTask _handlingData;
        private readonly Queue<IIdentifier> _dataQueue = new();
        private CancellationTokenSource _updateCancellationSource;

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
            inputReader.OnJumpReleased += StopJump;
            inputReader.OnGlidePressed += SetWantsToGlide;
            inputReader.OnGlideReleased += UnsetWantsToGlide;
            _updateCancellationSource = new CancellationTokenSource();
            var combinedToken = CancellationTokenSource.CreateLinkedTokenSource(_updateCancellationSource.Token, destroyCancellationToken);
            UpdateFsm(combinedToken.Token).Forget();
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
                {
                    if (enableLog)
                        this.Log($"Setting up view ({view})");
                    view.Setup(_character);
                }
            }
            if (_character != null)
                Setup(_character);
        }

        private async UniTaskVoid UpdateFsm(CancellationToken token)
        {
            while (!token.IsCancellationRequested)
            {
                await UniTask.Yield(token);
                if (_fsm == null)
                    continue;

                var transition = await _fsm.TryGetTransition(Actor, token);
                if (transition != null)
                    await Actor.Act<(IActor<ReverseIndexStore> actor, ITransition<IActor<ReverseIndexStore>, IIdentifier> transition)>
                        (_fsm.DoTransition, (Actor, transition), token, transition.Id);
                else
                    await _fsm.Current.TryHandleDataChanged(Actor, token);
            }
        }

        private void OnDisable()
        {
            _enableCoroutine.TryStop(this);
            if (inputReaderProvider.Ref.TryGetValue(out var inputReader))
            {
                inputReader.OnMoveInput -= HandleMoveInput;
                inputReader.OnJumpPressed -= StartJump;
                inputReader.OnJumpReleased -= StopJump;
                inputReader.OnGlidePressed -= SetWantsToGlide;
                inputReader.OnGlideReleased -= UnsetWantsToGlide;
            }

            _fsm?.End(Actor, destroyCancellationToken).Forget();
            _handlingData.Forget();
            _updateCancellationSource?.Cancel();
            _updateCancellationSource?.Dispose();
        }

        public void Setup(IPhysicsCharacter<ReverseIndexStore> data)
        {
            _character = data;
            Actor.Data.Set(characterId.Get, _character);
            Actor.Data.Set(actorId.Ref, _character.Actor);
            Actor.Data.Set(traversalInputId.Ref, Vector2.zero);
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
            
            //TODO: Remove when finished creating the delayedHandler. We just keep these lines as an example
            // _glideDelay = new StateDelayedHandler<IActor<ReverseIndexStore>>(secondsBeforeGlide, TransitionToGlide);
            // jump.Ref.OnEnter.Add(_glideDelay.Handle);
            // walk.Ref.OnEnter.Add(_glideDelay.Cancel);
            // idle.Ref.OnEnter.Add(_glideDelay.Cancel);
            _fsm = new ConditionalStateMachine<IActor<ReverseIndexStore>, IIdentifier>(name)
                       .ThatLogs(Debug.unityLogger, enableStateLogs)
                       .ThatTransitionsFrom(walk.Ref).To(idle.Ref).When(nameof(WantsToStop), WantsToStop).WithId(stopId).Apply()
                       .ThatTransitionsFrom(walkWhileFalling.Ref).To(fall.Ref).When(nameof(WantsToStop), WantsToStop).WithId(fallId).Apply()

                       .ThatTransitionsFrom(idle.Ref).To(walk.Ref).When(nameof(WantsToTraverse), WantsToTraverse).WithId(moveId).Apply()
                       .ThatTransitionsFrom(fall.Ref).To(walkWhileFalling.Ref).When(nameof(WantsToTraverse), WantsToTraverse).WithId(moveId).Apply()

                       .ThatTransitionsFrom(idle.Ref).To(jump.Ref).When(nameof(WantsToJump), WantsToJump).WithId(jumpId).Apply()
                       .ThatTransitionsFrom(walk.Ref).To(jump.Ref).When(nameof(WantsToJump), WantsToJump).WithId(jumpId).Apply()

                       .ThatTransitionsFrom(idle.Ref).To(fall.Ref).When(nameof(IsFalling), IsFalling).WithId(fallId).Apply()
                       .ThatTransitionsFrom(walk.Ref).To(fall.Ref).When(nameof(IsFalling), IsFalling).WithId(fallId).Apply()
                       .ThatTransitionsFrom(jump.Ref).To(fall.Ref).When(nameof(IsFalling), IsFalling).WithId(fallId).Apply()

                       .ThatTransitionsFrom(fall.Ref).To(idle.Ref).When(nameof(IsGrounded), IsGrounded).WithId(landId).Apply()
                       .ThatTransitionsFrom(walkWhileFalling.Ref).To(walk.Ref).When(nameof(IsGrounded), IsGrounded).WithId(landId).Apply()
                       .ThatTransitionsFrom(glide.Ref).To(walk.Ref).When(nameof(IsGrounded), IsGrounded).WithId(landId).Apply()

                       .ThatTransitionsFrom(fall.Ref).To(glide.Ref).When(nameof(WantsToGlide), WantsToGlide).WithId(glideId.Ref).Apply()
                       .ThatTransitionsFrom(walkWhileFalling.Ref).To(glide.Ref).When(nameof(WantsToGlide), WantsToGlide).WithId(glideId.Ref).Apply()

                       .ThatTransitionsFrom(glide.Ref).To(fall.Ref).When(nameof(NeitherWantsToGlideNorTraverse), NeitherWantsToGlideNorTraverse).WithId(fallId).Apply()
                       .ThatTransitionsFrom(glide.Ref).To(walkWhileFalling.Ref).When(nameof(DoesNotWantToGlideButWantsToTraverse), DoesNotWantToGlideButWantsToTraverse).WithId(fallId).Apply();

            await _fsm.Start(idle.Ref, Actor, destroyCancellationToken);

            var fallingController = character?.FallingController;

            if (fallingController == null)
            {
                Debug.LogError($"{name}: {nameof(fallingController)} component was not found in character!");
                return;
            }

            fallingController.OnStartFalling += HandleStartFalling;

            fallingController.OnStopFalling += HandleStopFalling;

            bool WantsToTraverse(IActor<ReverseIndexStore> actor)
                => Actor.Data.TryGet(traversalInputId.Ref, out Vector2 input)
                   && input.magnitude > 0.001f;

            bool WantsToStop(IActor<ReverseIndexStore> actor)
                => !WantsToTraverse(actor);

            bool WantsToJump(IActor<ReverseIndexStore> actor)
                => Actor.Data.TryGet(jumpId.Get, out float inputTime)
                   && Time.time - inputTime < 0.1f;

            bool IsFalling(IActor<ReverseIndexStore> actor)
                => actor.Data.TryGet(fallId, out bool input)
                   && input;

            bool IsGrounded(IActor<ReverseIndexStore> actor)
                => !IsFalling(actor);

            bool WantsToGlide(IActor<ReverseIndexStore> actor)
                => actor.Data.TryGet(glideId.Ref, out bool input)
                   && input;

            bool DoesNotWantToGlideButWantsToTraverse(IActor<ReverseIndexStore> actor)
                => !actor.Data.TryGet(glideId.Ref, out bool input)
                   || !input
                   && WantsToTraverse(actor);

            bool NeitherWantsToGlideNorTraverse(IActor<ReverseIndexStore> actor)
                => !actor.Data.TryGet(glideId.Ref, out bool input)
                   || !input
                   && !WantsToTraverse(actor);;
        }

        private void HandleStartFalling()
        {
            //TODO: Add a condition class that handles this
            // if (!Actor.Data.TryGet(glideId.Ref, out bool wantsToGlide))
            // {
            //     Debug.LogWarning($"{name}: Actor doesn't contain wantToGlide value");
            //     return;
            // }
            // AddData(wantsToGlide ? glideId.Ref : fallId.Get);
            Actor.Data.Set(fallId, true);
        }

        private void HandleStopFalling()
        {
            Actor.Data.Set(fallId, false);
        }

        private void StartJump()
        {
            Actor.Data.Set(jumpId.Get, Time.time);
        }

        private void StopJump()
        {
            Actor.Data.Set(jumpId.Get, float.NegativeInfinity);
        }

        private void SetWantsToGlide()
        {
            //TODO: Add this behaviour to a Condition structure
            Actor.Data.Set(glideId.Ref, true);
        }

        private void UnsetWantsToGlide()
        {
            //TODO: Add this behaviour to a Condition structure
            Actor.Data.Set(glideId.Ref, false);
        }
        
        private void HandleMoveInput(Vector2 input)
        {
            //THOUGHT: Should there be a Condition SO that receives an Input and returns an ID so this logic is done by that structure?
            var stateId = input.magnitude > 0.001f ? moveId : stopId;

            Actor.Data.Set(traversalInputId.Ref, input);
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

    public class StateDelayedHandler<T>
    {
        public float Seconds { get; }
        public CancellationTokenSource TokenSource { get; set; }
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
            TokenSource.Dispose();
            TokenSource = new CancellationTokenSource();
            return UniTask.CompletedTask;
        }

        private async UniTaskVoid Start(T data, CancellationToken token)
        {
            try
            {
                Debug.Log($"Started. Seconds: {Seconds}");
                var linkedToken = CancellationTokenSource.CreateLinkedTokenSource(token, TokenSource.Token).Token;
                await UniTask.WaitForSeconds(Seconds, cancellationToken: TokenSource.Token);
                Debug.Log("help");
                _onFinished(data);
            }
            catch (Exception e)
            {
                UnityEngine.Debug.LogException(e);
                throw;
            }
        }
    }
}