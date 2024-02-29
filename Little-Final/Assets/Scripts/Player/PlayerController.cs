using System;
using System.Collections.Generic;
using Core;
using Core.Debugging;
using Core.Extensions;
using Core.Interactions;
using Core.Stamina;
using Events.Channels;
using Player.Abilities;
using Player.Collectables;
using Player.States;
using UnityEngine;
using UnityEngine.Events;
using Events.UnityEvents;
using HealthSystem.Runtime;
using HealthSystem.Runtime.Components;
using Player.Movement;
using VarelaAloisio.UpdateManagement.Runtime;
using Void = Player.States.Void;

namespace Player
{
    public class PlayerController : MonoBehaviour, IUpdateable, IInteractor, IStaminaContainer, IBuffable
    {
        public delegate void StateCallback(State state);

        #region Variables

        private Transform _myTransform;
        public PlayerView view;
        public Transform collectablePivot;
        public CollectableBag collectableBag;

        public List<Ability> AbilitiesOnLand,
            AbilitiesInAir,
            AbilitiesOnWall;


        //TODO implement prediction logic that fires this event when the direction is towards a cliff
        public Action OnFallFromCliff;

        [SerializeField]
        private GameManager gameManager;
        
        [SerializeField]
        private Transform climbCheckPivot;
        
        [Header("Interactions")]
        [SerializeField]
        private Transform interactionHelper;

        [SerializeField]
        private float interactionCheckRadius;

        [SerializeField]
        private LayerMask interactableLayer;

        [SerializeField] private ThrowConfig throwConfig;
        
        [SerializeField] private BoolEventChannel pauseChannel;

        [Header("Debug")]
        [SerializeField]
        private bool shouldLogTransitions = false;
        [SerializeField] private Debugger debugger;
        
        private IHealthComponent _healthComponent;
        private IPickable _itemPicked;

        [Obsolete]
        private Stamina.Stamina stamina;
        State state;
        public Throw ThrowState { get; private set; }
        private Vector3 _lastSafePosition;
        private Quaternion _lastSafeRotation;
        private bool isDead;
        private int _sceneIndex;

        public event StateCallback OnStateChanges = delegate { };

        public Action<float> OnPickCollectable
        {
            get => collectableBag.OnCollectableAdded;
            set => collectableBag.OnCollectableAdded = value;
        }

        public Action<float> onStaminaChange
        {
            get => stamina.OnStaminaChange;
            set => stamina.OnStaminaChange = value;
        }

        public Action<float> OnChangeSpeed = delegate { };
        public Action<string> OnSpecificAction = delegate { };
        public SmartEvent OnJump;
        public SmartEvent OnLongJump;
        public SmartEvent OnLand;
        public SmartEvent OnClimb;
        public FloatSmartEvent onBuffed = new();

        public UnityEvent OnMount;
        public UnityEvent OnRide;
        public UnityEvent OnDismount;
        public UnityEvent onPick;
        public UnityEvent onPutDown;
        public UnityEvent onThrew;

        public Action<bool> OnGlideChanges = delegate { };
        [SerializeField] private float _buffMultiplier = 1;

    #region Properties

        public IBody Body { get; private set; }
        public IStepUp StepUp { get; private set; }
        public bool JumpBuffer { get; set; }
        public bool LongJumpBuffer { get; set; }

        public float BuffMultiplier
        {
            get => _buffMultiplier;
            set
            {
                onBuffed.Invoke(value);
                _buffMultiplier = value;
            }
        }

        public Stamina.Stamina Stamina => stamina;
        public State State => state;

        public int SceneIndex => _sceneIndex;

        public Vector3 LastSafePosition => _lastSafePosition;

        public Transform ClimbCheckPivot => climbCheckPivot;

        public Transform InteractionHelper => interactionHelper;

        public float InteractionCheckRadius => interactionCheckRadius;
        public IRideable Rideable { get; set; }

        public Transform Transform => transform;

        public RaycastHit LastClimbHit { get; set; }

        public IPickable ItemPicked => _itemPicked;

        #endregion

        #endregion

        private void Reset()
        {
            _healthComponent ??= GetComponent<HealthComponent>() ?? gameObject.AddComponent<HealthComponent>();
        }

        private void OnValidate()
        {
            _healthComponent ??= GetComponent<HealthComponent>();
        }

        private void Awake()
        {
            _myTransform = transform;
            _sceneIndex = gameObject.scene.buildIndex;
            collectableBag = new CollectableBag(PP_Stats.CollectablesForReward,
                                                UpgradeStamina);
            Body = GetComponent<IBody>();
            StepUp = GetComponent<IStepUp>();
            stamina = new Stamina.Stamina(PP_Stats.InitialStamina,
                                        PP_Stats.StaminaRefillDelay,
                                        PP_Stats.StaminaRefillSpeed,
                                        SceneIndex);
            gameManager.Player = _myTransform;
            
            if (!throwConfig)
                debugger.LogError(name, $"{throwConfig} is null!", this);
            ThrowState = new Throw(throwConfig, debugger);
        }

        private void Start()
        {
            state = new Walk();
            state.OnStateEnter(this, SceneIndex);
        }

        private void OnEnable()
        {
            UpdateManager.Subscribe(this);
            SaveSafeState(transform.position, transform.rotation);
            if (_healthComponent != null || TryGetComponent(out _healthComponent))
            {
                if (_healthComponent.Health != null)
                    _healthComponent.Health.OnDeath += HandleDeath;
            }
            else
                this.LogError($"{nameof(_healthComponent)} is null!");
            pauseChannel.SubscribeSafely(HandlePause);
        }

        private void OnDisable()
        {
            UpdateManager.UnSubscribe(this);
            if (_healthComponent is { Health: not null })
                _healthComponent.Health.OnDeath -= HandleDeath;
            pauseChannel.UnsubscribeSafely(HandlePause);
        }

        public void ChangeState<T>() where T : State, new()
        {
            state.OnStateExit();
            state = new T();
            if (shouldLogTransitions)
                Debug.Log($"{name}changed to state: {state.GetType()}");
            OnStateChanges(state);
            state.OnStateEnter(this, SceneIndex);
        }
        
        public void ChangeState(string id)
        {
            state.OnStateExit();
            if (id != nameof(Throw))
                return;
            state = ThrowState;
            if (shouldLogTransitions)
                Debug.Log($"{name}changed to state: {state.GetType()}");
            OnStateChanges(state);
            state.OnStateEnter(this, SceneIndex);
        }

        public void RunAbilityList(in IEnumerable<Ability> abilities)
        {
            foreach (var ability in abilities)
            {
                if (!ability.ValidateTrigger(this))
                    continue;
                ability.Use(this);
                stamina.ConsumeStamina(ability.Stamina);
            }
        }

        public void OnUpdate()
        {
#if UNITY_EDITOR
            if (Input.GetKeyDown(KeyCode.O))
            {
                stamina.UpgradeMaxStamina(400);
                stamina.RefillCompletely();
            }
#endif

            state.OnStateUpdate();
        }

        public void SaveSafeState(Vector3 position, Quaternion rotation)
        {
            if (isDead)
                return;
            _lastSafePosition = position;
            _lastSafeRotation = rotation;
        }

        public void Revive()
        {
            isDead = false;
            stamina.RefillCompletely();
            ChangeState<Walk>();
            _healthComponent.Health.FullyHeal();
            _myTransform.position = LastSafePosition;
            _myTransform.rotation = _lastSafeRotation;
            Body.Push(Body.Velocity * -1);
        }

        public void ResetJumpBuffers()
        {
            JumpBuffer = false;
            LongJumpBuffer = false;
        }

        #region EventHandlers

        private void UpgradeStamina()
        {
            stamina.UpgradeMaxStamina(stamina.MaxStamina + PP_Stats.StaminaUpgrade);
            stamina.RefillCompletely();
        }

        private void HandlePause(bool obj)
        {
            if (obj)
                ChangeState<Void>();
            else
                ChangeState<Walk>();
        }

        private void HandleDeath()
        {
            if (isDead)
                return;
            isDead = true;
            ChangeState<Void>();
            new CountDownTimer(PP_Stats.DeadTime, Revive, SceneIndex).StartTimer();
        }

    #endregion

        public bool CanInteract(out IInteractable interactable)
        {
            Collider[] results = new Collider[5];
            if (Physics.OverlapSphereNonAlloc(interactionHelper.position,
                                            interactionCheckRadius,
                                            results,
                                            interactableLayer,
                                            QueryTriggerInteraction.Collide) > 0)
            {
                foreach (Collider current in results)
                {
                    if (!current)
                        break;
                    if (current.TryGetComponent(out interactable))
                        return true;
                }
            }

            interactable = null;
            return false;
        }

        [Obsolete]
        public bool CanMount(out IRideable rideable)
        {
            Collider[] results = new Collider[5];
            if (Physics.OverlapSphereNonAlloc(interactionHelper.position,
                                            interactionCheckRadius,
                                            results,
                                            interactableLayer,
                                            QueryTriggerInteraction.Collide) > 0)
            {
                foreach (Collider current in results)
                {
                    if (!current)
                        break;
                    if (current.TryGetComponent(out rideable))
                        return true;
                }
            }

            rideable = null;
            return false;
        }

        public void Pick(IPickable pickable)
        {
            _itemPicked = pickable;
            pickable.Interact(this);
            onPick.Invoke();
        }

        public bool HasItem() => ItemPicked != null;

        public void PutDownItem()
        {
            ItemPicked.Leave();
            LoseInteraction();
        }

        /// <summary>
        /// Throws the held item
        /// </summary>
        /// <param name="force">Force based on transform direction to throw the item</param>
        public void ThrowItem(Vector3 force)
        {
            if (ItemPicked == null)
                return;
            ItemPicked.Throw(_myTransform.TransformDirection(force));
            _itemPicked = null;
            onThrew.Invoke();
        }
        
        public void LoseInteraction()
        {
            _itemPicked = null;
            onPutDown.Invoke();
        }

        public void Mount()
        {
            Transform mount = Rideable.GetMount();
            Rideable.Interact(this);
            _myTransform.SetParent(mount);
            _myTransform.SetPositionAndRotation(mount.position, mount.rotation);
            OnMount.Invoke();
        }

        public void Dismount()
        {
            transform.SetParent(null);
            Quaternion rotation = transform.rotation;
            transform.rotation = Quaternion.Euler(0, rotation.eulerAngles.y, 0);
            Rideable.Leave();
            OnDismount.Invoke();
        }
    }
}