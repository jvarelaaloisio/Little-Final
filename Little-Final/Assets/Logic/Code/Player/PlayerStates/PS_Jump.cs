using UnityEngine;
using CharacterMovement;
using UpdateManagement;
public class PS_Jump : PlayerState
{
	protected Transform transform;
	protected Player_Body body;
	protected CountDownTimer consumeStaminaPeriod,
		staminaConsumingDelay;
	public override void OnStateEnter(PlayerController brain)
	{
		base.OnStateEnter(brain);
		brain.view.ShowJumpFeedback();
		transform = brain.transform;
		//	Body
		body = brain.GetComponent<Player_Body>();
		body.BodyEvents += BodyEventsHandler;

		consumeStaminaPeriod = new CountDownTimer(1 / PP_Jump.Instance.GlideStaminaPerSecond, ConsumeStamina);
		staminaConsumingDelay = new CountDownTimer(PP_Jump.Instance.GlideStaminaConsumingDelay, null);
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
			Debug.DrawRay(transform.position, transform.up, Color.white);
			HorizontalMovementHelper.MoveWithRotation(transform,
														body,
														desiredDirection,
														PP_Jump.Instance.JumpSpeed,
														PP_Jump.Instance.TurnSpeedInTheAir);
		}
		else Debug.DrawRay(transform.position, transform.up, Color.black);

		ControlGlide();
		CheckForJumpBuffer();
		CheckClimb();
	}

	protected virtual void ControlGlide()
	{
		if (!InputManager.GetGlideInput() || brain.stamina.FillState < 1 || body.Velocity.y > 0)
		{
			body.TurnGlide(false);
			brain.view.SetFlying(false);
			consumeStaminaPeriod.StopTimer();

			return;
		}
		body.TurnGlide(true);
		brain.view.SetFlying(true);
		if (!consumeStaminaPeriod.IsTicking && !staminaConsumingDelay.IsTicking)
			consumeStaminaPeriod.StartTimer();
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

	protected void ConsumeStamina()
	{
		brain.stamina.ConsumeStamina(1);
		consumeStaminaPeriod.StartTimer();
	}

	public override void OnStateExit()
	{
		consumeStaminaPeriod.StopTimer();
		staminaConsumingDelay.StopTimer();
		body.BodyEvents -= BodyEventsHandler;
		body.TurnGlide(false);
	}
}
