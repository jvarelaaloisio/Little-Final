using Core.Extensions;
using Core.Movement;
using Player;
using UnityEngine;
using UnityEngine.Serialization;

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

		[Header("Interactions")]
		[SerializeField]
		private float eatingDistance;

		[SerializeField]
		private float viewDistance;

		[SerializeField]
		private LayerMask interactable;

		[SerializeField]
		private LayerMask walls;

		[SerializeField]
		protected float maxFloorDistance;

		[SerializeField]
		protected float foreseeingScale = .25f;

		[SerializeField]
		protected LayerMask floor;

		protected IMovement Movement;

		private bool _isMounted;

		public float Speed => speed;

		public Transform GetMount() => mount;

		public void Interact(Transform user)
		{
			_isMounted = true;
		}

		public void Leave()
		{
			_isMounted = false;
			Movement.Speed = speed;
		}

		protected abstract void InitializeMovement(out IMovement movement, float speed);

		protected abstract void Break();

		protected virtual void OnValidate()
		{
			if (!mount)
				mount = transform.Find("Mount")
						?? transform.Find("mount")
						?? transform.Find("MOUNT");
		}

		protected virtual void Awake()
		{
			InitializeMovement(out Movement, Speed);
		}

		protected virtual void Update()
		{
			if (_isMounted)
				return;
			Collider[] fruits = new Collider[1];
			if (Physics.OverlapSphereNonAlloc(transform.position,
											viewDistance,
											fruits,
											interactable) > 0)
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
			if (!_isMounted)
				return;

			//TODO: Tiene que seguir el mismo angulo que el piso y disminuir la fuerza hacia arriba cuanto más alto sea el angulo
			// if (direction.magnitude > .1f
			// 	&& Physics.Raycast(transform.position + direction * foreseeingScale,
			// 						Vector3.down,
			// 						out var hit,
			// 						maxFloorDistance,
			// 						floor))
			// {
			// 	direction.y = 1 - hit.normal.y;
			// 	Debug.DrawRay(transform.position, direction, Color.blue);
			// }
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
			Gizmos.DrawSphere(transform.position, viewDistance);
			Gizmos.DrawWireSphere(transform.position, viewDistance);
		}
	}
}