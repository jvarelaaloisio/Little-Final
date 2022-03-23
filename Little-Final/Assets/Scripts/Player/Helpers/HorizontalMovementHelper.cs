using Player;
using UnityEngine;

namespace CharacterMovement
{
	public static class HorizontalMovementHelper
	{
		public static Vector3 GetDirection(Vector2 input)
		{
			var cameraTransform = Camera.main.transform;
			var forward = cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			var right = cameraTransform.TransformDirection(Vector3.right);
			Vector3 direction = input.x * right + input.y * forward;
			return direction;
		}

		public static int GetLeastTravelDirection(Vector3 right, Vector3 desiredDirection)
		{
			float dot = Vector3.Dot(right, desiredDirection);
			var leastTravelDirection = dot < 0 ? -1 : 1;
			return leastTravelDirection;
		}

		public static void MoveWithRotation(
			Transform transform,
			IBody body,
			Vector3 desiredDirection,
			float speed,
			float turnSpeed)
		{
			if (!(desiredDirection.magnitude > .1f))
				return;
			desiredDirection.Normalize();
			float differenceRotation = Vector3.Angle(transform.forward, desiredDirection);

			var leastTravelDirection = GetLeastTravelDirection(transform.right, desiredDirection);
			transform.Rotate(transform.up, differenceRotation * leastTravelDirection * turnSpeed * Time.deltaTime);
			body.MoveHorizontally(transform.forward, speed);
		}

		public static void MoveWithRotationByForce(
			Transform transform,
			IBody body,
			Vector3 desiredDirection,
			float speed,
			float turnSpeed)
		{
			if (!(desiredDirection.magnitude > .1f))
				return;
			float rotationAngle = GetRotationAngleBasedOnDirection(transform, desiredDirection, turnSpeed);
			transform.Rotate(transform.up, rotationAngle);
			body.RequestForce(new ForceRequest(transform.forward * speed, ForceMode.Acceleration));
		}

		public static float GetRotationAngleBasedOnDirection(
			Transform transform,
			Vector3 movementDirection,
			float turnSpeed)
		{
			if (!(movementDirection.magnitude > .1f))
				return 0;
			movementDirection.Normalize();
			float differenceRotation = Vector3.Angle(transform.forward, movementDirection);

			var leastTravelDirection = GetLeastTravelDirection(transform.right, movementDirection);
			return differenceRotation * leastTravelDirection * turnSpeed * Time.deltaTime;
		}
		public static bool IsSafeAngle(Vector3 position,
												Vector3 direction,
												float maxDistance,
												float minDegrees)
		{
			if (Physics.Raycast(position, direction, out RaycastHit hit, maxDistance, ~LayerMask.GetMask("Interactable")) && hit.normal.y * Mathf.Rad2Deg > minDegrees)
			{
				Debug.DrawLine(position, hit.point, Color.red);
				return false;
			}
			Debug.DrawRay(position, direction * maxDistance, Color.green);
			return true;
		}
	}
}