using UnityEngine;

public static class HorizontalMovementHelper
{
	public static Vector3 GetDirection(Vector2 input)
	{
		var forward = Camera.main.transform.TransformDirection(Vector3.forward);
		forward.y = 0;
		var right = Camera.main.transform.TransformDirection(Vector3.right);
		Vector3 direction = input.x * right + input.y * forward;
		return direction;
	}
	
	public static int GetLeastTravelDirection(Transform transform, Vector3 desiredDirection)
	{
		float dot = Vector3.Dot(transform.right, desiredDirection);
		var leastTravelDirection = dot < 0 ? -1 : 1;
		return leastTravelDirection;
	}

	public static void moveWithRotation(Transform transform, IBody body, Vector3 desiredDirection, float speed, float turnSpeed)
	{
		if (desiredDirection.magnitude > .1f)
		{
			desiredDirection.Normalize();
			float differenceRotation = Vector3.Angle(transform.forward, desiredDirection);

			float dot = Vector3.Dot(transform.right, desiredDirection);
			var leastTravelDirection = GetLeastTravelDirection(transform, desiredDirection);
			transform.Rotate(transform.up, differenceRotation * leastTravelDirection * turnSpeed * Time.deltaTime);
			body.MoveHorizontally(transform.forward, speed);
		}
	}
}