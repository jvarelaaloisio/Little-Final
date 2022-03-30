using CharacterMovement;
using Player.PlayerInput;
using Player.Properties;
using Player.Stamina;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Walk : State
	{
		private IBody body;
		private CountDownTimer coyoteEffect;
		private StaminaConsumer _runningConsumer;
		private bool isRunning;

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			controller.OnLand();
			body = controller.GetComponent<PlayerBody>();
			isRunning = false;

			_runningConsumer = new StaminaConsumer(controller.Stamina,
													PP_Walk.RunStaminaPerSecond,
													sceneIndex);

			MyTransform = controller.transform;
			coyoteEffect
				= new CountDownTimer(PP_Jump.CoyoteTime,
									OnCoyoteFinished,
									sceneIndex
									);
			Physics.Raycast(MyTransform.position, -MyTransform.up, out RaycastHit hit, 10,
							~LayerMask.GetMask("Interactable"));
			body.LastFloorNormal = hit.normal;
			if (controller.JumpBuffer)
			{
				controller.ResetJumpBuffers();
				Jump();
			}
		}

		public override void OnStateUpdate()
		{
			Vector2 input = InputManager.GetHorInput();

			Controller.OnChangeSpeed(Mathf.Abs(input.normalized.magnitude / 2));

			Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
			Debug.DrawRay(MyTransform.position, desiredDirection.normalized / 3, Color.green);

			if (HorizontalMovementHelper.IsSafeAngle(MyTransform.position, desiredDirection.normalized, .3f,
													PP_Walk.MinSafeAngle))
			{
				if (input.magnitude > .1f && InputManager.CheckRunInput() && Controller.Stamina.FillState > 0)
				{
					if (!_runningConsumer.IsConsuming)
						_runningConsumer.Start();

					isRunning = true;
				}
				else if (_runningConsumer.IsConsuming)
				{
					_runningConsumer.Stop();
					isRunning = false;
				}

				HorizontalMovementHelper.Rotate(MyTransform,
															desiredDirection,
															desiredDirection.magnitude * PP_Walk.TurnSpeed);
				HorizontalMovementHelper.Move(MyTransform,
											body,
											desiredDirection,
											isRunning ? PP_Walk.RunSpeed : PP_Walk.Speed);
			}
			
			if (InputManager.CheckJumpInput())
				Jump();

			CheckClimb();
			ValidateGround();
			Controller.RunAbilityList(Controller.AbilitiesOnLand);
		}

		private void Jump()
		{
			// direction *= PP_Jump.InitialForceMultiplier;
			// direction.y = isRunning ? PP_Jump.LongJumpForce : PP_Jump.JumpForce;
			// body.Jump(direction);
			body.Jump(Vector3.up * (isRunning ? PP_Jump.LongJumpForce : PP_Jump.JumpForce));
			if (isRunning)
			{
				Controller.Stamina.ConsumeStamina(PP_Jump.LongJumpStaminaCost);
				Controller.ChangeState<LongJump>();
			}
			else
				Controller.ChangeState<Jump>();

			Controller.OnJump();
		}

		public override void OnStateExit()
		{
			coyoteEffect.StopTimer();
			_runningConsumer.Stop();
		}

		private void OnCoyoteFinished()
		{
			if (FallHelper.IsGrounded)
				return;
			Controller.ChangeState<Jump>();
			Controller.OnJump();
		}

		protected virtual void ValidateGround()
		{
			if (!FallHelper.IsGrounded && !coyoteEffect.IsTicking)
				coyoteEffect.StartTimer();
		}
	}
}