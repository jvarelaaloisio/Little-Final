using CharacterMovement;
using Player.PlayerInput;
using Player.Properties;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Walk : State
	{
		private IBody _body;
		private CountDownTimer _coyoteEffect;

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			controller.OnLand();
			_body = controller.GetComponent<Player_Body>();

			MyTransform = controller.transform;
			_coyoteEffect
				= new CountDownTimer(
					PP_Jump.CoyoteTime,
					OnCoyoteFinished,
					sceneIndex
				);
			Physics.Raycast(MyTransform.position, -MyTransform.up, out RaycastHit hit, 10,
				~LayerMask.GetMask("Interactable"));
			_body.LastFloorNormal = hit.normal;

			if (controller.LongJumpBuffer)
			{
				controller.ResetJumpBuffers();
				_body.Jump(PP_Jump.LongJumpForce);
				controller.ChangeState<LongJump>();
				Controller.OnJump();
			}
			else if (controller.JumpBuffer)
			{
				controller.ResetJumpBuffers();
				_body.Jump(PP_Jump.JumpForce);
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
				HorizontalMovementHelper.MoveWithRotation(
					MyTransform,
					_body,
					desiredDirection,
					PP_Walk.Instance.Speed,
					desiredDirection.magnitude * PP_Walk.Instance.TurnSpeed);
			}

			if (InputManager.CheckLongJumpInput())
			{
				_body.Jump(PP_Jump.LongJumpForce);
				Controller.ChangeState<LongJump>();
				Controller.OnJump();
			}
			else if (InputManager.CheckJumpInput())
			{
				_body.Jump(PP_Jump.JumpForce);
				Controller.ChangeState<Jump>();
				Controller.OnJump();
			}

			CheckClimb();
			ValidateGround();
			Controller.RunAbilityList(Controller.AbilitiesOnLand);
		}

		public override void OnStateExit()
		{
			_coyoteEffect.StopTimer();
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
			if (!FallHelper.IsGrounded && !_coyoteEffect.IsTicking)
				_coyoteEffect.StartTimer();
		}
	}
}