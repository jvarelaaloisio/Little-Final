using UnityEngine;
using CharacterMovement;
using UpdateManagement;

public class PS_Walk : PlayerState
{
	Transform transform;
	IBody body;
	CountDownTimer coyoteEffect;
	public override void OnStateEnter(PlayerController brain)
	{
		base.OnStateEnter(brain);
		brain.view.ShowLandFeedback();
		body = brain.GetComponent<Player_Body>();

		transform = brain.transform;
		coyoteEffect = new CountDownTimer(PP_Jump.Instance.CoyoteTime, OnCoyoteFinished);
		Physics.Raycast(transform.position, -transform.up, out RaycastHit hit, 10);
		body.LastFloorNormal = hit.normal;

		if (brain.LongJumpBuffer)
		{
			brain.ResetJumpBuffers();
			body.Jump(PP_Jump.Instance.LongJumpForce);
			brain.ChangeState<PS_LongJump>();
		}
		else if (brain.JumpBuffer)
		{
			brain.ResetJumpBuffers();
			body.Jump(PP_Jump.Instance.JumpForce);
			brain.ChangeState<PS_Jump>();
		}
	}

	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.GetHorInput();

		brain.view.SetSpeed(Mathf.Abs(input.y / 2));

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection.normalized / 2, Color.green);

		if (HorizontalMovementHelper.IsSafeAngle(transform.position, desiredDirection.normalized, .5f, PP_Walk.Instance.MinSafeAngle))
			HorizontalMovementHelper.MoveWithRotation(transform,
												body,
												desiredDirection,
												PP_Walk.Instance.Speed,
												PP_Walk.Instance.TurnSpeed);

		//		Picking
		//if (InputManager.ReadPickInput())
		//{
		//	brain.PickItem();
		//}

		if (InputManager.GetLongJumpInput())
		{
			body.Jump(PP_Jump.Instance.LongJumpForce);
			brain.ChangeState<PS_LongJump>();
		}
		else if (InputManager.GetJumpInput())
		{
			body.Jump(PP_Jump.Instance.JumpForce);
			brain.ChangeState<PS_Jump>();
		}
		CheckClimb();
		CheckGround();
	}

	public override void OnStateExit()
	{
		base.OnStateExit();
		coyoteEffect.StopTimer();
	}
	private void FinishCoyoteTime(string id)
	{
		if (!FallHelper.IsGrounded)
			brain.ChangeState<PS_Jump>();
	}
	private void OnCoyoteFinished()
	{
		if (!FallHelper.IsGrounded)
			brain.ChangeState<PS_Jump>();
	}
	protected virtual void CheckClimb()
	{
		if (InputManager.GetClimbInput() && brain.stamina.FillState > 0 && ClimbHelper.CanClimb(transform.position,
																								transform.forward,
																								PP_Climb.Instance.MaxDistanceToTriggerClimb,
																								PP_Climb.Instance.MaxClimbAngle,
																								out _))
		{
			brain.ChangeState<PS_Climb>();
		}
	}

	protected virtual void CheckGround()
	{
		if (!FallHelper.IsGrounded && !coyoteEffect.IsTicking)
			coyoteEffect.StartTimer();
	}
}