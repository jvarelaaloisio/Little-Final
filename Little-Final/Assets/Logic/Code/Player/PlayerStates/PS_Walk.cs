using UnityEngine;
using CharacterMovement;

public class PS_Walk : PlayerState
{
	Animator animator;
	Transform transform;
	IBody body;
	Timer_DEPRECATED coyoteTimer;
	public override void OnStateEnter(Player_Brain brain)
	{
		base.OnStateEnter(brain);
		animator = brain.GetComponent<Animator>();

		body = brain.GetComponent<Player_Body>();
		body.BodyEvents += BodyEventsHandler;

		transform = brain.transform;
		coyoteTimer = TimerHelper.SetupTimer(PP_Jump.Instance.CoyoteTime, "", brain.gameObject, FinishCoyoteTime);

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
		Vector2 input = InputManager.ReadHorInput();

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

		if (InputManager.ReadLongJumpInput())
		{
			body.Jump(PP_Jump.Instance.LongJumpForce);
			brain.ChangeState<PS_LongJump>();
		}
		else if (InputManager.ReadJumpInput())
		{
			body.Jump(PP_Jump.Instance.JumpForce);
			brain.ChangeState<PS_Jump>();
		}
		CheckClimb();
	}

	public override void OnStateExit()
	{
		base.OnStateExit();
		coyoteTimer.Stop();
		GameObject.Destroy(coyoteTimer);
		brain.Body.BodyEvents -= BodyEventsHandler;
	}
	private void FinishCoyoteTime(string id)
	{
		if (body.IsInTheAir)
			brain.ChangeState<PS_Jump>();
	}
	private void BodyEventsHandler(BodyEvent eventType)
	{
		if (eventType == BodyEvent.JUMP)
			coyoteTimer.Play();
	}
	protected virtual void CheckClimb()
	{
		if (InputManager.ReadClimbInput())
		{
			if (ClimbHelper.CanClimb(transform.position,
									transform.forward,
									PP_Climb.Instance.MaxDistanceToTriggerClimb,
									PP_Climb.Instance.MaxClimbAngle,
									out _))
			{
				brain.ChangeState<PS_Climb>();
			}
		}
	}
}