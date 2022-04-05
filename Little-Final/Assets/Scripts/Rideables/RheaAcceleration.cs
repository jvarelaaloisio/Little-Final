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

		[Header("sprint")]
		[SerializeField]
		private float sprintDuration;

		[SerializeField]
		private float sprintSpeed;

		[SerializeField]
		private float sprintCooldownTime;

		private Rigidbody _rigidbody;
		private float _sprintState = 1;
		private ActionOverTime _sprint;
		private CountDownTimer _sprintCooldown;
		private MovementRequest _nextMovement;
		private Vector3 direction;
		private void Awake()
		{
			_sprint = new ActionOverTime(sprintDuration,
										lerp => _sprintState = lerp,
										gameObject.scene.buildIndex,
										true);
			_sprintCooldown = new CountDownTimer(sprintCooldownTime,
												delegate { }, 
												gameObject.scene.buildIndex);
			_rigidbody = GetComponent<Rigidbody>();
		}

		private void FixedUpdate()
		{
			if(!_nextMovement.IsValid())
				return;
			
			float rotation = MoveHelper.GetRotationAngleBasedOnDirection(transform, direction, torque);
			_rigidbody.AddTorque(Vector3.up * rotation, ForceMode.Force);
			
			Vector3 acceleration = (_nextMovement.GetGoalVelocity() - _rigidbody.velocity).IgnoreY() * 1000 * Time.fixedDeltaTime;
			_rigidbody.AddForce(acceleration, ForceMode.Force);
		}

		public Transform GetMount()
		{
			return mount;
		}

		public void Move(Vector3 direction)
		{
			if (direction.magnitude < .1f)
			{
				_nextMovement = MovementRequest.InvalidRequest;
				return;
			}
			MoveHelper.Rotate(transform, direction, torque);
			
			this.direction = direction;
			float currSpeed = Mathf.Lerp(sprintSpeed, speed, _sprintState);
			_nextMovement = new MovementRequest(transform.forward, currSpeed);
		}

		public void UseAbility()
		{
			if (!_sprintCooldown.IsTicking)
			{
				_sprintCooldown.StartTimer();
				_sprint.StartAction();
			}
		}
	}
}