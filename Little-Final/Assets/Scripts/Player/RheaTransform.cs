using System;
using CharacterMovement;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player
{
	[RequireComponent(typeof(Rigidbody))]
	public class RheaTransform : MonoBehaviour, IRideable
	{
		[SerializeField]
		private float speed;

		[SerializeField]
		private Transform mount;

		[SerializeField]
		private float turnSpeed;

		[Header("sprint")]
		[SerializeField]
		private float sprintDuration;

		[SerializeField]
		private float sprintSpeed;

		[SerializeField]
		private float sprintCooldownTime;

		private float _sprintMultiplier = 1;
		private ActionOverTime _sprint;
		private CountDownTimer _sprintCooldown;

		private void Awake()
		{
			_sprint = new ActionOverTime(sprintDuration,
										lerp => _sprintMultiplier = lerp,
										gameObject.scene.buildIndex,
										true);
			_sprintCooldown = new CountDownTimer(sprintCooldownTime,
												delegate { }, 
												gameObject.scene.buildIndex);
		}

		public Transform GetMount()
		{
			return mount;
		}

		public void Move(Vector3 direction)
		{
			HorizontalMovementHelper.Rotate(transform, direction, turnSpeed);

			float currentSpeed = Mathf.Lerp(sprintSpeed, speed, _sprintMultiplier);
			transform.position += transform.forward * direction.magnitude * currentSpeed * Time.deltaTime;
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