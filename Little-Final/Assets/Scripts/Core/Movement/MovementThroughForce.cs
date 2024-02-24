using System.Collections;
using CharacterMovement;
using Core.Extensions;
using Player;
using UnityEngine;

namespace Core.Movement
{
	public class MovementThroughForce : IMovement
	{
		public float Speed { get; set; }

		private readonly Rigidbody _rigidbody;
		private readonly float _torque;
		private readonly WaitForFixedUpdate _waitForFixedUpdate = new WaitForFixedUpdate();
		private readonly MonoBehaviour _mono;

		public MovementThroughForce(MonoBehaviour mono,
									Rigidbody rigidbody,
									float speed,
									float torque)
		{
			_mono = mono;
			_rigidbody = rigidbody;
			_torque = torque;
			Speed = speed;
		}

		public void Move(Transform transform, Vector3 direction)
		{
			_mono.StopCoroutine(nameof(MoveInFixedUpdate));
			if (direction.magnitude < .1f)
				return;
			Debug.DrawRay(transform.position, transform.forward * Speed, Color.white);
			_mono.StartCoroutine(MoveInFixedUpdate(new MovementRequest(transform.forward, Speed, Speed)));
		}

		public void Rotate(Transform transform, Vector3 direction)
			=> Rotate(transform, direction, _torque);

		public void Rotate(Transform transform, Vector3 direction, float torque)
		{
			if(_rigidbody.velocity.IgnoreY().magnitude >= 0)
				MoveHelper.Rotate(transform, direction, torque);
		}

		private IEnumerator MoveInFixedUpdate(MovementRequest movement)
		{
			yield return _waitForFixedUpdate;
			Vector3 acceleration = (movement.GetGoalVelocity() - _rigidbody.velocity).IgnoreY()
									* (1000 * Time.fixedDeltaTime);
			_rigidbody.AddForce(acceleration, ForceMode.Force);
		}
	}
}