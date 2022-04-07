using CharacterMovement;
using Core.Extensions;
using Player;
using UnityEngine;
using UnityEngine.PlayerLoop;

namespace Core.Movement
{
	public class MovementThroughForce : IMovement
	{
		public float Speed { get; set; }

		private readonly Rigidbody _rigidbody;
		private MovementRequest _nextMovement;

		public MovementThroughForce(AdvancedMonoBehaviour mono, Rigidbody rigidbody, float speed)
		{
			mono.OnFixedUpdate += FixedUpdate;
			_rigidbody = rigidbody;
			Speed = speed;
			_nextMovement = MovementRequest.InvalidRequest;
		}

		public void Move(Transform transform, Vector3 direction)
		{
			if (direction.magnitude < .1f)
			{
				_nextMovement = MovementRequest.InvalidRequest;
				return;
			}

			_nextMovement = new MovementRequest(transform.forward, Speed);
		}

		public void Rotate(Transform transform, Vector3 direction, float torque)
		{
			if (_nextMovement.IsValid())
				MoveHelper.Rotate(transform, direction, torque);
		}

		private void FixedUpdate(MonoBehaviour mono, float fixedDeltaTime)
		{
			if (!_nextMovement.IsValid())
				return;

			Vector3 acceleration = (_nextMovement.GetGoalVelocity() - _rigidbody.velocity).IgnoreY()
									* (1000 * fixedDeltaTime);
			_rigidbody.AddForce(acceleration, ForceMode.Force);
		}
	}
}