using CharacterMovement;
using Core.Extensions;
using Player;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Rideables
{
	[RequireComponent(typeof(Rigidbody))]
	public class RheaAcceleration : MonoBehaviour, IRideable
	{
		[SerializeField]
		private float speed;

		[SerializeField]
		private Transform mount;

		[SerializeField]
		private float torque;

		[SerializeField]
		private float breakCooldown;

		[SerializeField]
		private float breakMultiplier;
		
		private Rigidbody _rigidbody;
		private float _sprintState = 1;
		private ActionOverTime _sprint;
		private CountDownTimer _breakCooling;
		private MovementRequest _nextMovement;
		private Vector3 direction;

		private void Awake()
		{
			_breakCooling = new CountDownTimer(breakCooldown,
												delegate { },
												gameObject.scene.buildIndex);
			_rigidbody = GetComponent<Rigidbody>();
		}

		private void FixedUpdate()
		{
			if (!_nextMovement.IsValid())
				return;

			float rotation = MoveHelper.GetRotationAngleBasedOnDirection(transform, direction, torque);
			_rigidbody.AddTorque(Vector3.up * rotation, ForceMode.Force);

			Vector3 acceleration = (_nextMovement.GetGoalVelocity() - _rigidbody.velocity).IgnoreY() * 1000 *
									Time.fixedDeltaTime;
			_rigidbody.AddForce(acceleration, ForceMode.Force);
		}

		public Transform GetMount()
		{
			return mount;
		}

		public void Move(Vector3 direction)
		{
			if (direction.magnitude < .1f || _breakCooling.IsTicking)
			{
				_nextMovement = MovementRequest.InvalidRequest;
				return;
			}

			MoveHelper.Rotate(transform, direction, torque);

			this.direction = direction;
			_nextMovement = new MovementRequest(transform.forward, speed);
		}

		public void UseAbility()
		{
			//TODO:Que frene solo estando en el piso
			if (!_breakCooling.IsTicking)
			{
				_breakCooling.StartTimer();
				_rigidbody.AddForce(-_rigidbody.velocity.IgnoreY(), ForceMode.VelocityChange);
			}
		}
	}
}