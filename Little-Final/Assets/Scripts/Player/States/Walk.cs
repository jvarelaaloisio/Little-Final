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
		private float currentSpeed;
		private StaminaConsumer runningConsumer;

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			controller.OnLand();
			body = controller.GetComponent<Player_Body>();

			currentSpeed = PP_Walk.Instance.Speed;
			runningConsumer = new StaminaConsumer(
				controller.Stamina,
				PP_Walk.Instance.RunStaminaPerSecond,
				sceneIndex);

			MyTransform = controller.transform;
			coyoteEffect
				= new CountDownTimer(
					PP_Jump.CoyoteTime,
					OnCoyoteFinished,
					sceneIndex
				);
			Physics.Raycast(MyTransform.position, -MyTransform.up, out RaycastHit hit, 10,
				~LayerMask.GetMask("Interactable"));
			body.LastFloorNormal = hit.normal;

			if (controller.LongJumpBuffer)
			{
				controller.ResetJumpBuffers();
				body.Jump(PP_Jump.LongJumpForce);
				controller.ChangeState<LongJump>();
				Controller.OnJump();
			}
			else if (controller.JumpBuffer)
			{
				controller.ResetJumpBuffers();
				body.Jump(PP_Jump.JumpForce);
				controller.ChangeState<Jump>();
				Controller.OnJump();
			}
		}

		public override void OnStateUpdate()
		{
			Vector2 input = InputManager.GetHorInput();

			Controller.OnChangeSpeed(Mathf.Abs(input.normalized.magnitude / 2));

			Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
			Debug.DrawRay(MyTransform.position, desiredDirection.normalized / 3, Color.green);

			if (HorizontalMovementHelper.IsSafeAngle(MyTransform.position, desiredDirection.normalized, .3f,
				    PP_Walk.Instance.MinSafeAngle))
			{
				if (InputManager.CheckRunInput() && Controller.Stamina.FillState > 0)
				{
					if (!runningConsumer.IsConsuming)
						runningConsumer.Start();

					currentSpeed = PP_Walk.Instance.RunSpeed;
				}
				else if (runningConsumer.IsConsuming)
				{
					runningConsumer.Stop();
					currentSpeed = PP_Walk.Instance.Speed;
				}

				HorizontalMovementHelper.MoveWithRotation(
					MyTransform,
					body,
					desiredDirection,
					currentSpeed,
					desiredDirection.magnitude * PP_Walk.Instance.TurnSpeed);
			}

			if (InputManager.CheckLongJumpInput())
			{
				body.Jump(PP_Jump.LongJumpForce);
				Controller.ChangeState<LongJump>();
				Controller.OnJump();
			}
			else if (InputManager.CheckJumpInput())
			{
				body.Jump(PP_Jump.JumpForce);
				Controller.ChangeState<Jump>();
				Controller.OnJump();
			}

			CheckClimb();
			ValidateGround();
			Controller.RunAbilityList(Controller.AbilitiesOnLand);
		}

		public override void OnStateExit()
		{
			coyoteEffect.StopTimer();
			runningConsumer.Stop();
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