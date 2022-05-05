using System.Collections;
using Core.Extensions;
using Core.Movement;
using UnityEngine;
using UnityEngine.Serialization;

namespace Rideables
{
	[RequireComponent(typeof(Rigidbody))]
	public class RheaAcceleration : Rhea
	{
		[SerializeField]
		private Rigidbody rigidBody;

		[SerializeField]
		private float breakForce;

		private readonly WaitForFixedUpdate _waitForFixedUpdate = new WaitForFixedUpdate();

		[Header("Stick to Floor")]
		[SerializeField]
		private float normalFloorDistance;

		[SerializeField]
		private float floorStickiness;

		[SerializeField]
		private AnimationCurve floorStickinessEvolution;

		private bool _isForcingFloor;


		protected override void OnValidate()
		{
			base.OnValidate();
			if (!rigidBody) gameObject.TryGetComponent(out rigidBody);
		}

		protected override void Awake()
		{
			base.Awake();
			// StartCoroutine(ForceFloor());
		}

		protected override void InitializeMovement(out IMovement movement, float speed)
		{
			movement = new MovementThroughForce(this, rigidBody, speed);
		}

		protected override void Break()
		{
			StopCoroutine(AddBreakForce());
			StartCoroutine(AddBreakForce());

			IEnumerator AddBreakForce()
			{
				yield return _waitForFixedUpdate;
				Vector3 force = -rigidBody.velocity.IgnoreY() * breakForce * Time.fixedDeltaTime;
				Debug.DrawRay(transform.position, force, Color.white);
				rigidBody.AddForce(force, ForceMode.Force);
			}
		}

		//TODO: Borrar si puedo hacer que el movimiento en la clase rhea siga el angulo del piso
		//y se corrige el tema de que salga volando
		private IEnumerator ForceFloor()
		{
			while (true)
			{
				yield return _waitForFixedUpdate;
				if (Physics.Raycast(transform.position + rigidBody.velocity.normalized * .25f,
									Vector3.down,
									out var hit,
									maxFloorDistance,
									floor)
					&& hit.distance > normalFloorDistance)
				{
					float force = Mathf.Lerp(0,
											floorStickiness,
											floorStickinessEvolution.Evaluate(hit.distance - normalFloorDistance));
					rigidBody.AddForce(Vector3.down * force);
				}
			}
		}
		// protected override void Update()
		// {
		// 	if (!_isForcingFloor
		// 		&& Physics.Raycast(transform.position,
		// 							Vector3.down,
		// 							out var hit,
		// 							maxFloorDistance,
		// 							floor)
		// 		&& hit.distance > normalFloorDistance)
		// 	{
		// 		Debug.Log($"hit distance: {hit.distance}");
		// 		Vector3 desiredPosition = hit.point + Vector3.up * normalFloorDistance;
		// 		StartCoroutine(ForceFloor(desiredPosition.y, 2, floorStickiness));
		// 	}
		//
		// 	base.Update();
		// }
		//
		// private IEnumerator ForceFloor(float desiredY, float maxDistance, float force)
		// {
		// 	_isForcingFloor = true;
		// 	Debug.Log("forcing floor");
		// 	float distance;
		// 	do
		// 	{
		// 		yield return _waitForFixedUpdate;
		// 		distance = transform.position.y - desiredY;
		// 		Vector3 currentForce = Vector3.down * Mathf.Lerp(0,
		// 														force * Time.fixedDeltaTime,
		// 														distance / maxDistance);
		// 		rigidBody.AddForce(currentForce, ForceMode.Force);
		// 		Debug.Log(distance);
		// 	} while (distance > .1f);
		//
		// 	Debug.Log("Floored");
		// 	_isForcingFloor = false;
		// }

#if UNITY_EDITOR

		[ContextMenu("Set Normal Floor Distance")]
		private void SetNormalFloorDistance()
		{
			if (Physics.Raycast(transform.position,
								Vector3.down,
								out var hit,
								maxFloorDistance,
								floor))
				normalFloorDistance = Vector3.Distance(hit.point, transform.position);
			else
				Debug.Log("Couldn't collide with floor");
		}
#endif
	}
}