using Core.Interactions;
using Core.Movement;
using Player;
using UnityEngine;
using UnityEngine.Events;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Rideables
{
	public abstract class Rhea : MonoBehaviour, IRideable
	{
		[Header("Setup")]
		[SerializeField]
		private Transform mount;

		[SerializeField]
		private int damageWhenEatingFruit = 1000;

		[Header("Movement")]
		[SerializeField]
		protected float speed;

		[Header("Rotation")]
		[SerializeField]
		protected float torque;

		[SerializeField]
		protected float torqueWhenMounted;

		[SerializeField]
		private AnimationCurve torqueTransitionToAvoidCrash = AnimationCurve.Linear(0, 0, 1, 1);

		[Header("Break")]
		[SerializeField]
		private float breakCooldown;

		[Header("Interactions")]
		[SerializeField]
		private float eatingDistance;

		[SerializeField]
		private float viewDistance;

		[SerializeField]
		private LayerMask interactables;

		[SerializeField]
		private LayerMask walls;

		[Header("Events")]
		[SerializeField]
		protected UnityEvent onBreak;

		[SerializeField]
		protected UnityEvent onBroke;

		protected IMovement Movement;
		private CountDownTimer _breakCooling;

		private bool _isMounted;

		public Transform GetMount() => mount;

		public void Interact(Transform user)
		{
			_isMounted = true;
		}

		public void Leave()
		{
			_isMounted = false;
			Break();
		}

		protected abstract void InitializeMovement(out IMovement movement, float speed);

		protected abstract void Break();

		private void OnValidate()
		{
			if (!mount)
				mount = transform.Find("Mount")
						?? transform.Find("mount")
						?? transform.Find("MOUNT");
		}

		protected virtual void Awake()
		{
			_breakCooling = new CountDownTimer(breakCooldown,
												onBroke.Invoke,
												gameObject.scene.buildIndex);
			InitializeMovement(out Movement, speed);
		}

		protected void Update()
		{
			if (_isMounted)
				return;
			Collider[] fruits = new Collider[1];
			if (Physics.OverlapSphereNonAlloc(transform.position,
											viewDistance,
											fruits,
											interactables) > 0)
			{
				Debug.DrawLine(transform.position, fruits[0].transform.position, Color.cyan);
				Vector3 direction = fruits[0].transform.position - transform.position;
				if (Vector3.Distance(transform.position, fruits[0].transform.position) <= eatingDistance
					&& fruits[0].TryGetComponent(out IDamageable damageable))
				{
					damageable.DamageHandler.TakeDamage(damageWhenEatingFruit);
				}

				Movement.Move(transform, direction);
				Movement.Rotate(transform, direction, torque);
			}
		}

		public void Move(Vector3 direction)
		{
			if (_breakCooling.IsTicking || !_isMounted)
				return;

			Movement.Move(transform, direction);
			Movement.Rotate(transform,
							direction,
							GetTorqueBasedOnPossibleCrash(torqueWhenMounted,
														torque,
														viewDistance,
														walls));

			float GetTorqueBasedOnPossibleCrash(float minTorque, float maxTorque, float awareDistance, LayerMask layer)
			{
				return Physics.Raycast(transform.position,
										transform.forward,
										out var hit,
										awareDistance,
										layer)
							? Mathf.Lerp(maxTorque,
										minTorque,
										torqueTransitionToAvoidCrash.Evaluate(hit.distance / awareDistance))
							: minTorque;
			}
		}

		public void UseAbility()
		{
			if (_breakCooling.IsTicking)
				return;
			_breakCooling.StartTimer();
			Break();
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(.0f, .75f, .25f, .1f);
			Gizmos.DrawSphere(transform.position, viewDistance);
			Gizmos.DrawWireSphere(transform.position, viewDistance);
		}
	}
}