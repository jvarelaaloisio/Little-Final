using System;
using System.Collections;
using System.Collections.Generic;
using Core;
using Core.Interactions;
using Core.Stamina;
using Player.Abilities;
using Player.Collectables;
using Player.States;
using UnityEngine;
using UnityEngine.Events;
using Events.UnityEvents;
using VarelaAloisio.UpdateManagement.Runtime;
using Void = Player.States.Void;

namespace Player
{
    public class PlayerController : MonoBehaviour, IUpdateable, IDamageHandler, IPlayer, IInteractor, IStaminaContainer
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

        [SerializeField]
        private float throwDelay;

        [Header("Debug")]
        [SerializeField]
        private bool shouldLogTransitions = false;

        private IPickable _itemPicked;
        IBody body;
        DamageHandler damageHandler;
        private Stamina.Stamina stamina;
        State state;
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

        public UnityEvent OnMount;
        public UnityEvent OnDismount;
        public UnityEvent onPick;
        public UnityEvent onPutDown;
        public UnityEvent onThrowing;
        public UnityEvent onThrew;

        public SmartEvent onDeath;

        public Action<bool> OnGlideChanges = delegate { };
        
        #region Properties

        public IBody Body => body;
        public bool JumpBuffer { get; set; }
        public bool LongJumpBuffer { get; set; }
        public Stamina.Stamina Stamina => stamina;
        public State State => state;
        public DamageHandler DamageHandler => damageHandler;

        public int SceneIndex => _sceneIndex;

        public Vector3 LastSafePosition => _lastSafePosition;

        public Transform ClimbCheckPivot => climbCheckPivot;

        public Transform InteractionHelper => interactionHelper;

        public float InteractionCheckRadius => interactionCheckRadius;
        public IRideable Rideable { get; private set; }

        public Transform Transform => transform;

        public RaycastHit LastClimbHit { get; set; }

        public IPickable ItemPicked => _itemPicked;

        #endregion

        #endregion


        private void Awake()
        {
            _myTransform = transform;
            _sceneIndex = gameObject.scene.buildIndex;
            collectableBag = new CollectableBag(PP_Stats.CollectablesForReward,
                                                UpgradeStamina);
            body = GetComponent<IBody>();
            damageHandler = new DamageHandler(PP_Stats.LifePoints, PP_Stats.ImmunityTime, OnLifeChanged, _sceneIndex);
            stamina = new Stamina.Stamina(PP_Stats.InitialStamina,
                                        PP_Stats.StaminaRefillDelay,
                                        PP_Stats.StaminaRefillSpeed,
                                        SceneIndex);
            gameManager.Player = _myTransform;
        }

        private void Start()
        {
            state = new Walk();
            state.OnStateEnter(this, SceneIndex);
        }

        private void OnEnable()
        {
            UpdateManager.Subscribe(this);
        }

        private void OnDisable()
        {
            UpdateManager.UnSubscribe(this);
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
            damageHandler.ResetLifePoints();
            _myTransform.position = LastSafePosition;
            _myTransform.rotation = _lastSafeRotation;
            body.Push(body.Velocity * -1);
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

        private void OnLifeChanged(float lifePoints)
        {
            if (isDead || !(lifePoints < 0)) return;
            isDead = true;
            onDeath.Invoke();
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

        public void ThrowItem(float force)
        {
            onThrowing.Invoke();
            StartCoroutine(ThrowItemAfterDelay(throwDelay));

            IEnumerator ThrowItemAfterDelay(float delay)
            {
                yield return new WaitForSeconds(delay);
                if (ItemPicked != null)
                {
                    ItemPicked.Throw(force, _myTransform.forward + _myTransform.up);
                    _itemPicked = null;
                    onThrew.Invoke();
                }
            }
        }

        public void LoseInteraction()
        {
            _itemPicked = null;
            onPutDown.Invoke();
        }

        public void Mount(IRideable rideable)
        {
            Rideable = rideable;
            Transform mount = rideable.GetMount();
            rideable.Interact(this);
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