using System.Collections;
using Core.Extensions;
using Core.Movement;
using UnityEngine;

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


		protected override void OnValidate()
		{
			base.OnValidate();
			if (!rigidBody) gameObject.TryGetComponent(out rigidBody);
		}

		protected override void InitializeMovement(out IMovement movement, float speed)
		{
			movement = new MovementThroughForce(this, rigidBody, speed, torque);
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

#if UNITY_EDITOR

		[ContextMenu("Set Normal Floor Distance")]
		private void SetNormalFloorDistance()
		{
			if (Physics.Raycast(transform.position,
								Vector3.down,
								out var hit,
								maxFloorDistance,
								floor))
				Vector3.Distance(hit.point, transform.position);
			else
				Debug.Log("Couldn't collide with floor");
		}
#endif
	}
}