using Core.Extensions;
using UnityEngine;

namespace Views
{
	public class RotateTowardsVelocity : CharacterView
	{
		[SerializeField] private bool ignoreY = true;
		[SerializeField] private float speed = 15.0f;
		[SerializeField] private double minimumSpeedToRotate = 0.01;
		[SerializeField] private bool drawGizmos;

		private void Update()
		{
			var direction = character.Velocity;
			if (ignoreY)
				direction = direction.IgnoreY();
			if (direction.magnitude < minimumSpeedToRotate)
				return;
			direction.Normalize();
			var targetYaw = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;

			var currentEuler = transform.eulerAngles;
			var currentYaw = currentEuler.y;

			var newYaw = Mathf.LerpAngle(currentYaw, targetYaw, speed * Time.deltaTime);

			transform.rotation = Quaternion.Euler(currentEuler.x, newYaw, currentEuler.z);

			if (!drawGizmos)
				return;
			Debug.DrawRay(transform.position, transform.forward, Color.red);
			Debug.DrawRay(transform.position, direction, Color.green);
		}
	}
}