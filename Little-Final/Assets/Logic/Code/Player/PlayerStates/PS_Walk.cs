using UnityEngine;
using CharacterMovement;
using VarelaAloisio.UpdateManagement.Runtime;

public class PS_Walk : PlayerState
{
	Transform transform;
	IBody body;
	CountDownTimer coyoteEffect;

	public override void OnStateEnter(PlayerController controller, int sceneIndex)
	{
		base.OnStateEnter(controller, sceneIndex);
		controller.OnLand();
		body = controller.GetComponent<Player_Body>();

		transform = controller.transform;
		coyoteEffect = new CountDownTimer(PP_Jump.Instance.CoyoteTime,
			OnCoyoteFinished,
			sceneIndex);
		Physics.Raycast(transform.position, -transform.up, out RaycastHit hit, 10, ~LayerMask.GetMask("Interactable"));
		body.LastFloorNormal = hit.normal;

		if (controller.LongJumpBuffer)
		{
			controller.ResetJumpBuffers();
			body.Jump(PP_Jump.Instance.LongJumpForce);
			controller.ChangeState<PS_LongJump>();
			Controller.OnJump();
		}
		else if (controller.JumpBuffer)
		{
			controller.ResetJumpBuffers();
			body.Jump(PP_Jump.Instance.JumpForce);
			controller.ChangeState<PS_Jump>();
			Controller.OnJump();
		}
	}

	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.GetHorInput();

		Controller.OnChangeSpeed(Mathf.Abs(input.normalized.magnitude / 2));

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection.normalized / 3, Color.green);

		if (HorizontalMovementHelper.IsSafeAngle(transform.position, desiredDirection.normalized, .3f,
			PP_Walk.Instance.MinSafeAngle))
		{
			HorizontalMovementHelper.MoveWithRotation(transform,
				body,
				desiredDirection,
				PP_Walk.Instance.Speed,
				PP_Walk.Instance.TurnSpeed);
		}

		if (InputManager.CheckLongJumpInput())
		{
			body.Jump(PP_Jump.Instance.LongJumpForce);
			Controller.ChangeState<PS_LongJump>();
			Controller.OnJump();
		}
		else if (InputManager.CheckJumpInput())
		{
			body.Jump(PP_Jump.Instance.JumpForce);
			Controller.ChangeState<PS_Jump>();
			Controller.OnJump();
		}

		ValidateClimb();
		ValidateGround();
		Controller.RunAbilityList(Controller.AbilitiesOnLand);
	}

	public override void OnStateExit()
	{
		base.OnStateExit();
		coyoteEffect.StopTimer();
	}

	private void OnCoyoteFinished()
	{
		if (FallHelper.IsGrounded)
			return;
		Controller.ChangeState<PS_Jump>();
		Controller.OnJump();
	}

	protected virtual void ValidateClimb()
	{
		if (InputManager.CheckClimbInput()
		    && Controller.stamina.FillState > 0
		    && ClimbHelper.CanClimb(transform.position,
			    transform.forward,
			    PP_Climb.MaxDistanceToTriggerClimb,
			    PP_Climb.MaxClimbAngle,
			    out _))
		{
			Controller.ChangeState<PS_Climb>();
		}
	}

	protected virtual void ValidateGround()
	{
		if (!FallHelper.IsGrounded && !coyoteEffect.IsTicking)
			coyoteEffect.StartTimer();
	}
}