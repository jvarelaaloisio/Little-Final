using System;
using System.Collections.Generic;
using Core.Attributes;
using Core.Debugging;
using Core.Extensions;
using Core.Helpers;
using Core.Interactions;
using Core.Movement;
using Events.Channels;
using Events.UnityEvents;
using FSM;
using Rideables.States;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Events;
using UnityEngine.Serialization;

namespace Rideables
{
	public abstract class Rhea : MonoBehaviour, IRideable
	{
		private const string MOVEMENT_DEBUG_TAG = "Movement";

		#region Variables

		[Header("Setup")]
		[SerializeField]
		private Transform mount;

		[SerializeField]
		private Awareness awareness;

		[SerializeField]
		[ExposeScriptableObject]
		private RheaModel rheaModel;

		[SerializeField]
		private float eatingPeriod;

		[SerializeField]
		private float eatingFirstDelay;

		[SerializeField]
		private int eatingDamage;

		[SerializeField]
		private float goToFruitTolerance = .25f;

		[Header("Movement")]
		[SerializeField]
		private float speed;

		[SerializeField]
		private AnimationCurve runningSpeedControl = AnimationCurve.Linear(0, 0, 1, 1);

		[SerializeField]
		private AnimationCurve speedControlWhenApproachingWall = AnimationCurve.Linear(0, 0, 1, 1);

		[Header("Rotation")]
		[SerializeField]
		protected float torque;

		[SerializeField]
		protected float torqueWhenMounted;

		[SerializeField]
		private AnimationCurve torqueTransitionToAvoidCrash = AnimationCurve.Linear(0, 0, 1, 1);

		[SerializeField]
		private float viewDistance;

		[SerializeField]
		private LayerMask walls;

		[SerializeField]
		protected float maxFloorDistance;

		[SerializeField]
		protected float foreseeingScale = .25f;

		[SerializeField]
		protected LayerMask floor;

		[FormerlySerializedAs("eatId")]
		[Header("Decision result keys")]
		[SerializeField]
		private IdContainer eatIdContainer;

		[FormerlySerializedAs("goToFruitId")] [SerializeField]
		private IdContainer goToFruitIdContainer;

		[FormerlySerializedAs("fleeFromPlayerId")] [SerializeField]
		private IdContainer fleeFromPlayerIdContainer;

		[FormerlySerializedAs("idleId")] [SerializeField]
		private IdContainer idleIdContainer;

		[FormerlySerializedAs("patrolId")] [SerializeField]
		private IdContainer patrolIdContainer;

		[Header("Event channels listened")]
		[Tooltip("Can be null")]
		[SerializeField]
		private VoidChannelSo playerDeathChannel;

		[Header("Events")]
		[SerializeField]
		private UnityEvent onCompletedObjective;

		[SerializeField]
		private UnityEvent onMounted;

		[SerializeField]
		private UnityEvent onDismounted;

		[SerializeField]
		private UnityEvent onEating;

		[SerializeField]
		private SmartEvent onFinishedFruit;

		[SerializeField]
		private UnityEvent onStoppedEating;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;

		protected IMovement Movement;
		protected INavigator Navigator;

		protected bool IsMounted;
		private float _runningStart;
		private Vector3 _lastMoveDirection;

		private FiniteStateMachine<IdContainer> _stateMachine;
		private CharacterState<IdContainer> _idle;
		private Eat<IdContainer> _eat;
		private Navigate<IdContainer> _goToFruit;
		private Navigate<IdContainer> _fleeFromPlayer;
		private Navigate<IdContainer> _patrol;

		public event Action OnCompletedObjective = delegate { };
		public event Action OnMounted = delegate { };
		public event Action OnDismounted = delegate { };

		public event Action OnEating = delegate { };
		public event Action OnStoppedEating = delegate { };

		public float Speed => speed;

		public Transform GetMount() => mount;

		#endregion

		protected virtual void OnValidate()
		{
			if (!mount)
				mount = transform.Find("Mount")
						?? transform.Find("mount")
						?? transform.Find("MOUNT");
			if (!awareness
				&& !TryGetComponent(out awareness))
				awareness = transform.GetComponentInChildren<Awareness>();
		}

		private void OnEnable()
		{
			playerDeathChannel.SubscribeSafely(OnPlayerDies);
		}

		private void OnDisable()
		{
			playerDeathChannel.UnsubscribeSafely(OnPlayerDies);
		}

		protected virtual void Awake()
		{
			InitializeMovement(out Movement, Speed);
			InitializeNavigator(out Navigator);
			awareness.OnEnvironmentChanged += OnEnvironmentChanged;
			_idle = new CharacterState<IdContainer>(idleIdContainer.Name, transform, OnStateCompletedObjective, debugger);

			_eat = new Eat<IdContainer>(eatIdContainer.Name,
								transform,
								OnStateCompletedObjective,
								debugger,
								awareness,
								eatingPeriod,
								eatingFirstDelay,
								eatingDamage,
								this);
			_eat.OnAwake += FireOnEating;
			_eat.OnSleep += FireOnStoppedEating;
			_eat.OnFinishedFruit += onFinishedFruit.Invoke;

			_goToFruit = new Navigate<IdContainer>(goToFruitIdContainer.Name,
										transform,
										OnStateCompletedObjective,
										debugger,
										Navigator);

			_fleeFromPlayer = new Navigate<IdContainer>(fleeFromPlayerIdContainer.Name,
												transform,
												OnStateCompletedObjective,
												debugger,
												Navigator);

			_patrol = new Navigate<IdContainer>(patrolIdContainer.Name,
										transform,
										OnStateCompletedObjective,
										debugger,
										Navigator);
			_patrol.OnAwake += () => _patrol.NavigateTo(GetPatrolCandidates());

			_idle.AddTransition(eatIdContainer, _eat);
			_idle.AddTransition(goToFruitIdContainer, _goToFruit);
			_idle.AddTransition(fleeFromPlayerIdContainer, _fleeFromPlayer);
			_idle.AddTransition(patrolIdContainer, _patrol);

			_eat.AddTransition(idleIdContainer, _idle);
			_eat.AddTransition(goToFruitIdContainer, _goToFruit);
			_eat.AddTransition(fleeFromPlayerIdContainer, _fleeFromPlayer);
			_eat.AddTransition(patrolIdContainer, _patrol);

			_goToFruit.AddTransition(idleIdContainer, _idle);
			_goToFruit.AddTransition(eatIdContainer, _eat);
			_goToFruit.AddTransition(fleeFromPlayerIdContainer, _fleeFromPlayer);
			_goToFruit.AddTransition(patrolIdContainer, _patrol);

			_fleeFromPlayer.AddTransition(idleIdContainer, _idle);
			_fleeFromPlayer.AddTransition(eatIdContainer, _eat);
			_fleeFromPlayer.AddTransition(goToFruitIdContainer, _goToFruit);
			_fleeFromPlayer.AddTransition(patrolIdContainer, _patrol);

			_patrol.AddTransition(idleIdContainer, _idle);
			_patrol.AddTransition(eatIdContainer, _eat);
			_patrol.AddTransition(goToFruitIdContainer, _goToFruit);
			_patrol.AddTransition(fleeFromPlayerIdContainer, _fleeFromPlayer);

			_stateMachine = FiniteStateMachine<IdContainer>.Build(_idle, name)
				.ThatLogsTransitions(Debug.unityLogger)
				.Done();
		}

		private void FireOnEating()
		{
			onEating.Invoke();
			OnEating();
		}

		private void FireOnStoppedEating()
		{
			onStoppedEating.Invoke();
			OnStoppedEating();
		}

		protected abstract void OnPlayerDies();

		private void OnEnvironmentChanged()
		{
			string currentStateName = _stateMachine.CurrentState.Name;
			if (currentStateName == goToFruitIdContainer.Name)
			{
				Transform fruit = awareness.Fruit;
				Vector3 fruitDestination;
				if (!fruit)
				{
					debugger.LogError(name, $"fruit not found when trying to set destination");
					fruitDestination = transform.position;
				}
				else
				{
					Vector3 fruitPosition = fruit.position;
					Vector3 directionToFruit = (fruitPosition - transform.position).normalized;
					fruitDestination = fruitPosition - directionToFruit * (rheaModel.EatDistance - goToFruitTolerance);
				}

				_goToFruit.NavigateTo(new[] {fruitDestination});
			}
			else if (currentStateName == fleeFromPlayerIdContainer.Name
					&& awareness.Player)
			{
				_fleeFromPlayer.NavigateTo(GetFleeCandidates(awareness.Player.position));
			}
		}

		protected void OnStateCompletedObjective()
		{
			onCompletedObjective.Invoke();
			OnCompletedObjective();
		}

		private Vector3[] GetFleeCandidates(Vector3 fleeFromPosition)
		{
			Vector3[] candidates = new Vector3[1];
			Vector3 fleeDirection = (transform.position - fleeFromPosition).IgnoreY().normalized;
			candidates[0] = transform.position + fleeDirection * rheaModel.FleeDistance;
			//TODO: Populate with multiple possible destinations
			return candidates;
		}

		private Vector3[] GetPatrolCandidates()
		{
			Vector3[] candidates = new Vector3[4];
			Vector3 myPos = transform.position;
			Vector3 forward = transform.forward;
			candidates[0] = myPos + forward * rheaModel.PatrolDistance;
			candidates[1] = myPos - forward * rheaModel.PatrolDistance;
			Vector3 right = transform.right;
			candidates[2] = myPos + right * rheaModel.PatrolDistance;
			candidates[3] = myPos - right * rheaModel.PatrolDistance;
			//TODO: Populate with multiple possible destinations
			return candidates;
		}

		protected virtual void Update()
		{
			//TODO: Mounted should be a state
			if (IsMounted)
				return;
			_stateMachine.Update(Time.deltaTime);
		}

		public void TransitionTo(IdContainer idContainer)
			=> _stateMachine.TransitionTo(idContainer);

		protected abstract void InitializeMovement(out IMovement movement, float speed);
		protected abstract void InitializeNavigator(out INavigator navigator);

		protected abstract void Brake();

		public virtual void Interact(IInteractor interactor)
		{
			IsMounted = true;
			TransitionTo(idleIdContainer);
			_runningStart = Time.time;
			onMounted.Invoke();
			OnMounted();
		}

		public virtual void Leave()
		{
			IsMounted = false;
			Movement.Speed = speed;
			onDismounted.Invoke();
			OnDismounted();
		}

		public void Move(Vector3 direction)
		{
			if (direction.magnitude < .01f
				&& Time.time - _runningStart > .25f)
			{
				debugger.Log(MOVEMENT_DEBUG_TAG, "Started moving", this);

				_runningStart = Time.time;
			}
			_lastMoveDirection = direction;

			float currentTorque = torqueWhenMounted;
			float currentSpeed = speed;
			if (IsApproachingWall(viewDistance, walls, out var wallHit)
				&& IsNotSlope())
			{
				float lerp = wallHit.distance / viewDistance;
				currentTorque = Mathf.Lerp(torque,
											torqueWhenMounted,
											torqueTransitionToAvoidCrash.Evaluate(lerp));
				currentSpeed = Mathf.Lerp(0,
										speed,
										speedControlWhenApproachingWall.Evaluate(lerp));
			}

			bool IsNotSlope()
			{
				debugger.DrawRay(MOVEMENT_DEBUG_TAG, wallHit.point, wallHit.normal, Color.blue);
				float angle = Vector3.Angle(wallHit.normal, Vector3.up);
				return angle > 45;
			}

			currentSpeed *= runningSpeedControl.Evaluate(Time.time - _runningStart);
			Movement.Speed = currentSpeed;
			Movement.Move(transform, direction);
			Movement.Rotate(transform,
							direction,
							currentTorque);
		}

		protected abstract Vector3 GetCurrentVelocity();

		private bool IsApproachingWall(float awareDistance, LayerMask layer, out RaycastHit hit)
		{
			return Physics.Raycast(transform.position,
									transform.forward,
									out hit,
									awareDistance,
									layer);
		}

		public void UseAbility()
		{
			Brake();
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(.0f, .75f, foreseeingScale, .1f);
			Gizmos.DrawWireSphere(transform.position, viewDistance);
		}
	}
}