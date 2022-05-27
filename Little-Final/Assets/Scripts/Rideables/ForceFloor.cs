using System;
using UnityEngine;

namespace Rideables
{
	public class ForceFloor : MonoBehaviour
	{
		[SerializeField]
		private float maxDistance;

		[SerializeField]
		private LayerMask floor;

		[SerializeField]
		private float desiredFloorDistance;

		[SerializeField]
		private float forceMultiplier;

		[SerializeField]
		private Rigidbody rigidBody;

		private void OnValidate()
		{
			if (!rigidBody) TryGetComponent(out rigidBody);
		}

		private void FixedUpdate()
		{
			if (IsFloorAtDistance(out var hit))
			{
				float upperBound = transform.position.y - hit.point.y - desiredFloorDistance;
				float downForce = Mathf.Clamp(upperBound, 0, maxDistance);
				rigidBody.AddForce(Vector3.down * downForce * forceMultiplier * Time.fixedDeltaTime);
			}
		}

		private bool IsFloorAtDistance(out RaycastHit hit)
		{
			return Physics.Raycast(transform.position,
									Vector3.down,
									out hit,
									maxDistance,
									floor);
		}

		private void OnDrawGizmosSelected()
		{
			if (IsFloorAtDistance(out var hit))
			{
				Debug.DrawLine(transform.position, hit.point, Color.gray);
				float upperBound = transform.position.y - hit.point.y - desiredFloorDistance;
				float downForce = Mathf.Clamp(upperBound, 0, maxDistance);
				Debug.DrawRay(transform.position + Vector3.down * desiredFloorDistance, Vector3.down * downForce, Color.blue);
			}
			else
				Debug.DrawRay(transform.position, Vector3.down * maxDistance, Color.black);
		}
#if UNITY_EDITOR

		[ContextMenu("Auto set Desired Floor Distance")]
		private void SetNormalFloorDistance()
		{
			if (Physics.Raycast(transform.position,
								Vector3.down,
								out var hit,
								maxDistance,
								floor))
				desiredFloorDistance = Vector3.Distance(hit.point, transform.position);
			else
				Debug.Log("Couldn't collide with floor");
		}
#endif
	}
}