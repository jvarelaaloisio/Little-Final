using CharacterMovement;
using UnityEngine;

namespace Core.Movement
{
	public class MovementThroughTransform : IMovement
	{
		private readonly float _torque;
		public float Speed { get; set; }

		public MovementThroughTransform(float speed, float torque)
		{
			_torque = torque;
			Speed = speed;
		}

		public void Move(Transform transform, Vector3 direction)
		{
			transform.position += direction * Speed * Time.deltaTime;
		}

		public void Rotate(Transform transform, Vector3 direction)
		{
			Rotate(transform, direction, _torque);
		}

		public void Rotate(Transform transform, Vector3 direction, float torque)
		{
			if (direction.magnitude > .1f)
				MoveHelper.Rotate(transform, direction, torque);
		}
	}
}