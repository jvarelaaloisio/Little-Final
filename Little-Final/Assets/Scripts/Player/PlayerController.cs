using System;
using System.Collections.Generic;
using Core.Extensions;
using Core.Interactions;
using Player.Abilities;
using Player.States;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
using Void = Player.States.Void;

namespace Player
{
	public class PlayerController : MonoBehaviour, IUpdateable, IDamageable
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

		public event StateCallback OnStateChanges = delegate { };
		public Action<float> OnPickCollectable = delegate { };
		public Action<float> OnStaminaChanges = delegate { };
		public Action<float> OnChangeSpeed = delegate { };
		public Action<string> OnSpecificAction = delegate { };
		public Action OnJump = delegate { };
		public Action OnLand = delegate { };
		public Action OnClimb = delegate { };
		public Action OnDeath = delegate { };
		public Action<bool> OnGlideChanges = delegate { };
		public Action OnFallFromCliff;

		[SerializeField]
		private Transform climbCheckPivot;

		[Header("Interactions")]
		[SerializeField]
		private Transform interactionHelper;

		[SerializeField]
		private float interactionCheckRadius;

		[SerializeField]
		private LayerMask interactableLayer;

		[Header("Debug")]
		[SerializeField]
		private bool shouldLogTransitions = false;

		IPickable _itemPicked;
		IBody body;
		DamageHandler damageHandler;
		private Stamina.Stamina stamina;
		State state;
		private Vector3 _lastSafePosition;
		private Quaternion _lastSafeRotation;
		private bool isDead;
		private int _sceneIndex;

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

		#endregion

		#endregion

		private void Start()
		{
			_myTransform = transform;
			collectableBag = new CollectableBag(
												PP_Stats.CollectablesForReward,
												UpgradeStamina,
												OnPickCollectable);
			UpdateManager.Subscribe(this);
			body = GetComponent<IBody>();
			damageHandler = new DamageHandler(PP_Stats.LifePoints, PP_Stats.ImmunityTime, OnLifeChanged, _sceneIndex);
			stamina = new Stamina.Stamina(
										PP_Stats.InitialStamina,
										PP_Stats.StaminaRefillDelay,
										PP_Stats.StaminaRefillSpeed,
										SceneIndex,
										OnStaminaChanges);
			state = new Walk();
			_sceneIndex = gameObject.scene.buildIndex;
			state.OnStateEnter(this, SceneIndex);
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
			OnDeath();
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
					if(!current)
						break;
					if(current.TryGetComponent(out interactable))
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
					if(!current)
						break;
					if(current.TryGetComponent(out rideable))
						return true;
				}
			}

			rideable = null;
			return false;
		}

		[Obsolete]
		public bool CanPick(out IPickable pickable)
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
					if(!current)
						break;
					if(current.TryGetComponent(out pickable))
						return true;
				}
			}

			pickable = null;
			return false;
		}

		public void Pick(IPickable pickable)
		{
			_itemPicked = pickable;
			pickable.Interact(_myTransform);
		}

		public bool HasItem() => _itemPicked != null;

		public void ReleaseItem()
		{
			_itemPicked.Leave();
			_itemPicked = null;
		}

		public void ThrowItem(float force)
		{
			_itemPicked.Throw(force, _myTransform.forward + _myTransform.up);
			_itemPicked = null;
		}

		public void Mount(IRideable rideable)
		{
			Rideable = rideable;
			Transform mount = rideable.GetMount();
			rideable.Interact(_myTransform);
			_myTransform.SetParent(mount);
			_myTransform.SetPositionAndRotation(mount.position, mount.rotation);
		}

		public void Dismount()
		{
			transform.SetParent(null);
			Rideable.Leave();
		}
	}
}