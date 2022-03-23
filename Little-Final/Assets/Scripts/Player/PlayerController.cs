using System;
using System.Collections.Generic;
using CharacterMovement;
using Player.Abilities;
using Player.PlayerInput;
using Player.Properties;
using Player.States;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
using Void = Player.States.Void;

namespace Player
{
	[RequireComponent(typeof(DamageHandler))]
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

		[SerializeField] private Transform climbCheckPivot;

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
			damageHandler.onLifeChanged += OnLifeChanged;
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
			// Debug.Log($"{name}changed to state: {state.GetType()}");
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
			if (Input.GetButtonDown("RefillStamina"))
			{
				stamina.UpgradeMaxStamina(400);
				stamina.RefillCompletely();
			}

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

		/// <summary>
		/// Reads the input and moves the player horizontally
		/// </summary>
		public void MoveByForce(float speed, float turnSpeed)
		{
			Vector2 input = InputManager.GetHorInput();

			Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);

			if (HorizontalMovementHelper.IsSafeAngle(
				    _myTransform.position,
				    desiredDirection.normalized,
				    .5f,
				    PP_Walk.Instance.MinSafeAngle))
				HorizontalMovementHelper.MoveWithRotationByForce(
					_myTransform,
					body,
					desiredDirection,
					speed,
					turnSpeed);
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
	}
}