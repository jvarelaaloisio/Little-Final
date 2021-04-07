using UnityEngine;
using CharacterMovement;
using VarelaAloisio.UpdateManagement.Runtime;

public class PS_Walk : PlayerState
{
	Transform transform;
	IBody body;
	CountDownTimer coyoteEffect;

	public override void OnStateEnter(PlayerModel model, int sceneIndex)
	{
		base.OnStateEnter(model, sceneIndex);
		model.view.ShowLandFeedback();
		body = model.GetComponent<Player_Body>();

		transform = model.transform;
		coyoteEffect = new CountDownTimer(PP_Jump.Instance.CoyoteTime,
			OnCoyoteFinished,
			sceneIndex);
		Physics.Raycast(transform.position, -transform.up, out RaycastHit hit, 10, ~LayerMask.GetMask("Interactable"));
		body.LastFloorNormal = hit.normal;

		if (model.LongJumpBuffer)
		{
			model.ResetJumpBuffers();
			body.Jump(PP_Jump.Instance.LongJumpForce);
			model.ChangeState<PS_LongJump>();
			base.Model.view.ShowJumpFeedback();
		}
		else if (model.JumpBuffer)
		{
			model.ResetJumpBuffers();
			body.Jump(PP_Jump.Instance.JumpForce);
			model.ChangeState<PS_Jump>();
			base.Model.view.ShowJumpFeedback();
		}
	}

	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.GetHorInput();

		Model.view.SetSpeed(Mathf.Abs(input.normalized.magnitude / 2));

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
			Model.ChangeState<PS_LongJump>();
			Model.view.ShowJumpFeedback();
		}
		else if (InputManager.CheckJumpInput())
		{
			body.Jump(PP_Jump.Instance.JumpForce);
			Model.ChangeState<PS_Jump>();
			Model.view.ShowJumpFeedback();
		}

		ValidateClimb();
		ValidateGround();
		Model.RunAbilityList(Model.AbilitiesOnLand);
	}

	public override void OnStateExit()
	{
		base.OnStateExit();
		coyoteEffect.StopTimer();
	}

	private void OnCoyoteFinished()
	{
		if (!FallHelper.IsGrounded)
		{
			Model.ChangeState<PS_Jump>();
			Model.view.ShowJumpFeedback();
		}
	}

	protected virtual void ValidateClimb()
	{
		if (InputManager.CheckClimbInput()
		    && Model.stamina.FillState > 0
		    && ClimbHelper.CanClimb(transform.position,
			    transform.forward,
			    PP_Climb.Instance.MaxDistanceToTriggerClimb,
			    PP_Climb.Instance.MaxClimbAngle,
			    out _))
		{
			Model.ChangeState<PS_Climb>();
		}
	}

	protected virtual void ValidateGround()
	{
		if (!FallHelper.IsGrounded && !coyoteEffect.IsTicking)
			coyoteEffect.StartTimer();
	}
}