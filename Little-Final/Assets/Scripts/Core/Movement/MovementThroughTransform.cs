using CharacterMovement;
using UnityEngine;

namespace Core.Movement
{
	public class MovementThroughTransform : IMovement
	{
		public float Speed { get; set; }

		public void Move(Transform transform, Vector3 direction)
		{
			transform.position += direction * Speed * Time.deltaTime;
		}

		public void Rotate(Transform transform, Vector3 direction, float torque)
		{
			if (direction.magnitude > .1f)
				MoveHelper.Rotate(transform, direction, torque);
		}

		public MovementThroughTransform(float speed)
		{
			Speed = speed;
		}
	}
}