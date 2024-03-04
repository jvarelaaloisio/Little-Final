using System;
using Player;
using UnityEngine;

namespace CharacterMovement
{
	public static class MoveHelper
	{
		private static readonly LayerMask InteractableLayerMask = LayerMask.GetMask("Interactable", "Fruit", "Player");
		public static Vector3 GetDirection(Vector2 input)
		{
			var cameraTransform = Camera.main.transform;
			var forward = cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			var right = cameraTransform.TransformDirection(Vector3.right);
			Vector3 direction = input.x * right + input.y * forward;
			return direction;
		}
		
		public static Vector2 GetInput(Vector3 direction)
		{
			var cameraTransform = Camera.main.transform;
			var forward = cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			var right = cameraTransform.TransformDirection(Vector3.right);

			Vector2 input;
			input.x = Vector3.Dot(direction, right);
			input.y = Vector3.Dot(direction, forward);
			return input;
		}

		public static void Move(Transform transform,
		                        IBody body,
		                        Vector3 desiredDirection,
		                        float speed,
		                        float acceleration)
		{
			if (!(desiredDirection.magnitude > .1f))
				body.RequestMovement(MovementRequest.InvalidRequest);
			body.RequestMovement(new MovementRequest(desiredDirection, speed, acceleration));
		}
		
		public static void MoveByForce(
			Transform transform,
			IBody body,
			Vector3 desiredDirection,
			float speed)
		{
			if (!(desiredDirection.magnitude > .1f))
				return;
			body.RequestMovementByForce(new ForceRequest(desiredDirection * speed, ForceMode.Force));
		}

		public static void Rotate(Transform transform, Vector3 desiredDirection, float turnSpeed)
		{
			float rotationAngle = GetRotationAngleBasedOnDirection(transform, desiredDirection, turnSpeed);
			transform.Rotate(transform.up, rotationAngle);
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

		private static int GetLeastTravelDirection(Vector3 right, Vector3 desiredDirection)
		{
			float dot = Vector3.Dot(right, desiredDirection);
			var leastTravelDirection = dot < 0 ? -1 : 1;
			return leastTravelDirection;
		}
		
		public static bool IsSafeAngle(Vector3 position,
												Vector3 direction,
												float maxDistance,
												float minDegrees)
		{
			if (Physics.Raycast(position, direction, out RaycastHit hit, maxDistance, ~InteractableLayerMask) && hit.normal.y * Mathf.Rad2Deg > minDegrees)
			{
				Debug.DrawLine(position, hit.point, Color.red);
				return false;
			}
			Debug.DrawRay(position, direction * maxDistance, Color.green);
			return true;
		}

		public static bool IsApproachingWall(Transform transform,
											float awareDistance,
											LayerMask walls,
											out RaycastHit hit)
		{
			return Physics.Raycast(transform.position,
									transform.forward,
									out hit,
									awareDistance,
									walls);
		}
		
		[Obsolete("Use StepUpBehaviour/IStepUp")]
		public static bool CanStepUp(Vector3 actualPosition,
		                             Vector3 up,
		                             Vector3 forward,
		                             float maxUpDistance,
		                             float maxForwardDistance,
		                             out RaycastHit hit)
		{
			hit = new RaycastHit();
			var upScaled = up * maxUpDistance;
			var forwardScaled = forward * maxForwardDistance;
			if (Physics.Raycast(actualPosition + upScaled, forward, maxForwardDistance, ~InteractableLayerMask))
				return false;
			Vector3 targetPosition = actualPosition + upScaled + forwardScaled;
			var canStepUp = Physics.Raycast(targetPosition, -up, out hit, maxUpDistance, ~InteractableLayerMask);
			if (canStepUp)
			{
				Debug.DrawRay(actualPosition + upScaled, forwardScaled, Color.green, 1f);
				Debug.DrawRay(targetPosition, -up * hit.distance, Color.red, 1f);
			}
			return canStepUp;
		}
	}
}