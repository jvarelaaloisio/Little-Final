using System.Collections;
using Core;
using Core.Extensions;
using Core.Helpers;
using Core.Interactions;
using Core.LifeSystem;
using Core.Movement;
using FSM;
using Player;
using Rideables.States;
using UnityEngine;
using UnityEngine.Events;

namespace Rideables
{
	public abstract class Rhea : MonoBehaviour, IRideable
	{
		[Header("Setup")]
		[SerializeField]
		private Transform mount;

		[SerializeField]
		private Awareness awareness;

		[SerializeField]
		private RheaModel rheaModel;

		[SerializeField]
		private float arrivalDistance;

		[SerializeField]
		private float eatingPeriod;

		[SerializeField]
		private float eatingFirstDelay;

		[SerializeField]
		private int eatingDamage;

		[Header("Movement")]
		[SerializeField]
		private float speed;

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

		[Header("Decision result keys")]
		[SerializeField]
		private Id eatId;

		[SerializeField]
		private Id goToFruitId;

		[SerializeField]
		private Id fleeFromPlayerId;

		[SerializeField]
		private Id idleId;

		[SerializeField]
		private Id patrolId;

		[Header("Events")]
		[SerializeField]
		private UnityEvent OnCompletedObjective;

		[SerializeField]
		private UnityEvent onMounted;

		[SerializeField]
		private UnityEvent onDismounted;

		protected IMovement Movement;

		private bool _isMounted;

		private FiniteStateMachine<Id> _stateMachine;

		public float Speed => speed;

		public Transform GetMount() => mount;

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

		protected virtual void Awake()
		{
			InitializeMovement(out Movement, Speed);
			var idle = new CharacterState<Id>("Idle", transform, OnCompletedObjective.Invoke);

			var eat = new CharacterState<Id>("Eat", transform, OnCompletedObjective.Invoke);
			eat.OnAwake += () => StartCoroutine(Eat());
			eat.OnSleep += () => StopCoroutine(Eat());

			IEnumerator Eat()
			{
				WaitForSeconds waitForPeriod = new WaitForSeconds(eatingPeriod);
				yield return new WaitForSeconds(eatingFirstDelay);
				while (true)
				{
					if (awareness.Fruit)
					{
						if (awareness.Fruit.TryGetComponent(out IDamageable damageable))
							damageable.TakeDamage(eatingDamage);
					}

					yield return waitForPeriod;
				}
			}

			var goToFruit = new Walk<Id>("go to fruit",
										transform,
										OnCompletedObjective.Invoke,
										Movement,
										() => awareness.Fruit
												? awareness.Fruit.position
												: transform.position,
										rheaModel.EatDistance);

			var fleeFromPlayer =
				new Walk<Id>("flee from player",
							transform,
							OnCompletedObjective.Invoke,
							Movement,
							() =>
							{
								Vector3 myPos = transform.position;
								return awareness.Player
											? myPos + (myPos - awareness.Player.position).IgnoreY().normalized *
											rheaModel.FleeDistance / 2
											: myPos;
							},
							arrivalDistance);

			var patrol = new Walk<Id>("patrol",
									transform,
									OnCompletedObjective.Invoke,
									Movement,
									() => transform.position,
									arrivalDistance);
			patrol.OnAwake += () => Debug.LogError("Patrol objective not set", this);

			idle.AddTransition(eatId, eat);
			idle.AddTransition(goToFruitId, goToFruit);
			idle.AddTransition(fleeFromPlayerId, fleeFromPlayer);
			idle.AddTransition(patrolId, patrol);

			eat.AddTransition(idleId, idle);
			eat.AddTransition(goToFruitId, goToFruit);
			eat.AddTransition(fleeFromPlayerId, fleeFromPlayer);
			eat.AddTransition(patrolId, patrol);

			goToFruit.AddTransition(idleId, idle);
			goToFruit.AddTransition(eatId, eat);
			goToFruit.AddTransition(fleeFromPlayerId, fleeFromPlayer);
			goToFruit.AddTransition(patrolId, patrol);

			fleeFromPlayer.AddTransition(idleId, idle);
			fleeFromPlayer.AddTransition(eatId, eat);
			fleeFromPlayer.AddTransition(goToFruitId, goToFruit);
			fleeFromPlayer.AddTransition(patrolId, patrol);

			patrol.AddTransition(idleId, idle);
			patrol.AddTransition(eatId, eat);
			patrol.AddTransition(goToFruitId, goToFruit);
			patrol.AddTransition(fleeFromPlayerId, fleeFromPlayer);
			_stateMachine = FiniteStateMachine<Id>.Build(idle, tag)
				.ThatLogsTransitions(Debug.unityLogger)
				.Done();
		}

		protected virtual void Update()
		{
			//TODO: Mounted should be a state
			if (_isMounted)
				return;
			_stateMachine.Update(Time.deltaTime);
		}

		public void TransitionTo(Id id)
			=> _stateMachine.TransitionTo(id);

		protected abstract void InitializeMovement(out IMovement movement, float speed);

		protected abstract void Break();

		public void Interact(IUser user)
		{
			_isMounted = true;
			onMounted.Invoke();
		}

		public void Leave()
		{
			_isMounted = false;
			Movement.Speed = speed;
			onDismounted.Invoke();
		}

		public void Move(Vector3 direction)
		{
			if (!_isMounted)
				return;

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
				Debug.DrawRay(wallHit.point, wallHit.normal, Color.blue);
				float angle = Vector3.Angle(wallHit.normal, Vector3.up);
				return angle > 45;
			}

			Movement.Speed = currentSpeed;
			Movement.Move(transform, direction);
			Movement.Rotate(transform,
							direction,
							currentTorque);
		}

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
			Break();
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(.0f, .75f, foreseeingScale, .1f);
			Gizmos.DrawWireSphere(transform.position, viewDistance);
		}
	}
}