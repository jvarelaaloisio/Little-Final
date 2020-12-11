using UnityEngine;
using CharacterMovement;

public class PS_Jump : PlayerState
{
	protected Transform transform;
	protected Player_Body body;
	public override void OnStateEnter(Player_Brain brain)
	{
		base.OnStateEnter(brain);
		brain.view.ShowJumpFeedback();
		transform = brain.transform;
		//	Body
		body = brain.GetComponent<Player_Body>();
		body.BodyEvents += BodyEventsHandler;

	}

	private void BodyEventsHandler(BodyEvent eventType)
	{
		if (eventType.Equals(BodyEvent.LAND) && FallHelper.IsGrounded)
		{
			brain.ChangeState<PS_Walk>();
		}
	}
	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.GetHorInput();

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection / 4, Color.green);

		if (HorizontalMovementHelper.IsSafeAngle(transform.position, desiredDirection.normalized, .5f, PP_Walk.Instance.MinSafeAngle))
		{
			HorizontalMovementHelper.MoveWithRotation(transform,
														body,
														desiredDirection,
														PP_Jump.Instance.JumpSpeed,
														PP_Jump.Instance.TurnSpeedInTheAir);
		}

		ControlGlide();
		CheckForJumpBuffer();
		CheckClimb();
	}

	protected virtual void ControlGlide()
	{
		body.TurnGlide(InputManager.GetGlideInput());
		brain.view.SetFlying(InputManager.GetGlideInput());
	}

	protected virtual void CheckClimb()
	{
		if (InputManager.GetClimbInput())
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


	protected virtual void CheckForJumpBuffer()
	{
		if (InputManager.GetLongJumpInput() && Physics.Raycast(transform.position, -transform.up, .5f))
		{
			brain.LongJumpBuffer = true;
		}
		else if (InputManager.GetJumpInput() && Physics.Raycast(transform.position, -transform.up, .5f))
		{
			brain.JumpBuffer = true;
		}
	}

	public override void OnStateExit()
	{
		body.BodyEvents -= BodyEventsHandler;
		body.TurnGlide(false);
	}
}
