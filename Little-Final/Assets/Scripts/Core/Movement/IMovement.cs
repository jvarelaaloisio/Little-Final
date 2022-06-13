using UnityEngine;

namespace Core.Movement
{
	public interface IMovement
	{
		float Speed { get; set; }
		void Move(Transform transform, Vector3 direction);
		void Rotate(Transform transform, Vector3 direction);
		void Rotate(Transform transform, Vector3 direction, float torque);
	}
}