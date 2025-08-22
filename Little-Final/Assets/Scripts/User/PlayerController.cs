using System;
using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.FSM;
using Core.Gameplay;
using Core.Helpers;
using Core.References;
using Core.Utils;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using FsmAsync;
using FsmAsync.Conditional;
using UnityEngine;

namespace User
{
    public class PlayerController : MonoBehaviour, ISetup<ICharacter<ReverseIndexStore>>
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
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> run;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> jump;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> fall;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> glide;
        [SerializeField] private InterfaceRef<IState<IActor<ReverseIndexStore>>> walkWhileFalling;
        
        [Header("Ids")]
        [SerializeField] private IdContainer characterId;
        [SerializeField] private InterfaceRef<IIdentifier> actorId;
        [SerializeField] private InterfaceRef<IIdentifier> traversalInputId;
        [SerializeField] private InterfaceRef<IIdentifier> runInputId;
        
        [SerializeField] private IdContainer stopId;
        [SerializeField] private IdContainer moveId;
        [SerializeField] private IdContainer jumpId;
        [SerializeField] private IdContainer fallId;
        [SerializeField] private IdContainer landId;
        [SerializeField] private IdContainer lastInputId;
        [SerializeField] private InterfaceRef<IIdentifier> runId;
        [SerializeField] private InterfaceRef<IIdentifier> glideId;

        [SerializeField] private float secondsBeforeGlide = 1;

        private ICharacter<ReverseIndexStore> _character;

        private ConditionalStateMachine<IActor<ReverseIndexStore>, IIdentifier> _fsm;
        private AutoMap<Texture2D> BlackTexture = new(() => new Texture2D(1, 1));
        private StateDelayedHandler<IActor<ReverseIndexStore>> _glideDelay;

        private UniTask _handlingData;
        private readonly Queue<IIdentifier> _dataQueue = new();
        private CancellationTokenSource _updateTokenSource;
        private CancellationTokenSource _enableTokenSource;

        public IActor<ReverseIndexStore> Actor => _character.Actor;

        private async void OnEnable()
        {
            if (!inputReaderProvider.HasValue)
            {
                this.LogError($"{nameof(inputReaderProvider)} is null!");
                return;
            }

            try
            {
                _enableTokenSource = new CancellationTokenSource();
                var linkedSource = CancellationTokenSource.CreateLinkedTokenSource(destroyCancellationToken,
                                                                                   _enableTokenSource.Token);

                var inputReader = await inputReaderProvider.Ref.GetValueAsync(linkedSource.Token);
                inputReader.OnMoveInput += HandleMoveInput;
                inputReader.OnRunInput += HandleRunInput;
                inputReader.OnJumpPressed += StartJump;
                inputReader.OnJumpReleased += StopJump;
                inputReader.OnGlidePressed += SetWantsToGlide;
                inputReader.OnGlideReleased += UnsetWantsToGlide;
            }
            catch (OperationCanceledException)
            {
                Debug.LogWarning($"{nameof(PlayerController)} Input reader was never provided during enable.");
                return;
            }
            catch (Exception e)
            {
                Debug.LogException(e, this);
            }
            _updateTokenSource = new CancellationTokenSource();
            var combinedToken = CancellationTokenSource.CreateLinkedTokenSource(_updateTokenSource.Token, destroyCancellationToken);
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
            _enableTokenSource?.Cancel();
            _enableTokenSource?.Dispose();
            _enableTokenSource = null;
            _updateTokenSource?.Cancel();
            _updateTokenSource?.Dispose();
            _updateTokenSource = null;
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
        }

        public void Setup(ICharacter<ReverseIndexStore> data)
        {
            _character = data;
            Actor.Data.Set(characterId.Get, _character);
            Actor.Data.Set(actorId.Ref, _character.Actor);
            Actor.Data.Set(traversalInputId.Ref, Vector3.zero);
            SetupFsm(_character);
        }

        private async void SetupFsm(ICharacter character)
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
                       .ThatTransitionsFrom(walk.Ref).To(idle.Ref).WhenNot(nameof(WantsToTraverse), WantsToTraverse).WithId(stopId).Apply()
                       .ThatTransitionsFrom(walkWhileFalling.Ref).To(fall.Ref).WhenNot(nameof(WantsToTraverse), WantsToTraverse).WithId(fallId).Apply()

                       .ThatTransitionsFrom(idle.Ref).To(walk.Ref).When(nameof(WantsToTraverse), WantsToTraverse).WithId(moveId).Apply()
                       .ThatTransitionsFrom(fall.Ref).To(walkWhileFalling.Ref).When(nameof(WantsToTraverse), WantsToTraverse).WithId(moveId).Apply()

                       .ThatTransitionsFrom(walk.Ref).To(run.Ref).When(nameof(WantsToRunAndHasStamina), WantsToRunAndHasStamina).WithId(runId.Ref).Apply()
                       .ThatTransitionsFrom(run.Ref).To(walk.Ref).WhenNot(nameof(WantsToRunAndHasStamina), WantsToRunAndHasStamina).WithId(moveId).Apply()

                       .ThatTransitionsFrom(idle.Ref).To(jump.Ref).When(nameof(WantsToJump), WantsToJump).WithId(jumpId).Apply()
                       .ThatTransitionsFrom(walk.Ref).To(jump.Ref).When(nameof(WantsToJump), WantsToJump).WithId(jumpId).Apply()
                       .ThatTransitionsFrom(run.Ref).To(jump.Ref).When(nameof(WantsToJump), WantsToJump).WithId(jumpId).Apply()

                       .ThatTransitionsFrom(idle.Ref).To(fall.Ref).When(nameof(IsFalling), IsFalling).WithId(fallId).Apply()
                       .ThatTransitionsFrom(walk.Ref).To(fall.Ref).When(nameof(IsFalling), IsFalling).WithId(fallId).Apply()
                       .ThatTransitionsFrom(run.Ref).To(fall.Ref).When(nameof(IsFalling), IsFalling).WithId(fallId).Apply()
                       .ThatTransitionsFrom(jump.Ref).To(fall.Ref).When(nameof(IsFalling), IsFalling).WithId(fallId).Apply()

                       .ThatTransitionsFrom(fall.Ref).To(idle.Ref).WhenNot(nameof(IsFalling), IsFalling).WithId(landId).Apply()
                       .ThatTransitionsFrom(walkWhileFalling.Ref).To(walk.Ref).WhenNot(nameof(IsFalling), IsFalling).WithId(landId).Apply()
                       .ThatTransitionsFrom(glide.Ref).To(walk.Ref).WhenNot(nameof(IsFalling), IsFalling).WithId(landId).Apply()

                       .ThatTransitionsFrom(fall.Ref).To(glide.Ref).When(nameof(WantsToGlide), WantsToGlide).WithId(glideId.Ref).Apply()
                       .ThatTransitionsFrom(walkWhileFalling.Ref).To(glide.Ref).When(nameof(WantsToGlide), WantsToGlide).WithId(glideId.Ref).Apply()

                       .ThatTransitionsFrom(glide.Ref).To(fall.Ref).When(nameof(NeitherWantsToGlideNorTraverse), NeitherWantsToGlideNorTraverse).WithId(fallId).Apply()
                       .ThatTransitionsFrom(glide.Ref).To(walkWhileFalling.Ref).When(nameof(DoesNotWantToGlideButWantsToTraverse), DoesNotWantToGlideButWantsToTraverse).WithId(fallId).Apply()

                       .ThatTransitionsFrom(glide.Ref).To(fall.Ref).When(nameof(OutOfStamina), OutOfStamina).WithId(fallId).Apply();


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
                => actor.Data[typeof(Vector3), traversalInputId.Ref] is Vector3 { magnitude: > 0.001f };

            bool WantsToRunAndHasStamina(IActor<ReverseIndexStore> actor)
                => actor.Data.TryGet(runInputId.Ref, out bool input)
                   && input
                   && !OutOfStamina(actor);

            bool WantsToJump(IActor<ReverseIndexStore> actor)
                => actor.Data.TryGet(jumpId.Get, out float inputTime)
                   && Time.time - inputTime < 0.1f;

            bool IsFalling(IActor<ReverseIndexStore> actor)
                => actor.Data.TryGet(fallId, out bool isFalling)
                   && isFalling;

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
                   && !WantsToTraverse(actor);

            bool OutOfStamina(IActor<ReverseIndexStore> actor)
                => character.Stamina.Current <= 0;
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
            => Actor.Data.Set(traversalInputId.Ref, input.XYtoXZY());
        private void HandleRunInput(bool input)
            => Actor.Data.Set(runInputId.Ref, input);

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
            var goalSpeed = _character?.Movement.goalSpeed;
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