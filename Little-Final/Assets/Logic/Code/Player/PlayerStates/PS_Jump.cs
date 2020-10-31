using UnityEngine;
using CharacterMovement;
using UnityEditor.MemoryProfiler;

public class PS_Jump : PlayerState
{
	protected Transform transform;
	protected Player_Body body;
	protected Animator animator;
	public override void OnStateEnter(Player_Brain brain)
	{
		base.OnStateEnter(brain);
		transform = brain.transform;

		//	Body
		body = brain.GetComponent<Player_Body>();
		body.BodyEvents += BodyEventsHandler;


		animator = brain.GetComponent<Animator>();
	}

	private void BodyEventsHandler(BodyEvent eventType)
	{
		if (eventType.Equals(BodyEvent.LAND))
			brain.ChangeState<PS_Walk>();
	}
	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.ReadHorInput();

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
		body.TurnGlide(InputManager.ReadGlideInput());
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

	protected virtual void CheckForJumpBuffer()
	{
		if (InputManager.ReadLongJumpInput() && Physics.Raycast(transform.position, -transform.up, .5f))
		{
			brain.LongJumpBuffer = true;
		}
		else if (InputManager.ReadJumpInput() && Physics.Raycast(transform.position, -transform.up, .5f))
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
