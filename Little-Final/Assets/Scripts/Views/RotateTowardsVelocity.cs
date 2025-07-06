using Core.Attributes;
using Core.Extensions;
using UnityEngine;

namespace Views
{
	public class RotateTowardsVelocity : CharacterView
	{
		[SerializeField] private bool ignoreY = true;
		[SerializeField] private float speed = 10.0f;
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
			var signedAngle = Vector3.SignedAngle(transform.forward, direction, transform.up);
			if (drawGizmos)
			{
				Debug.DrawRay(transform.position, transform.forward, Color.red);
				Debug.DrawRay(transform.position, direction, Color.green);
			}
			transform.Rotate(transform.up, signedAngle * speed * Time.deltaTime);
		}
	}
}