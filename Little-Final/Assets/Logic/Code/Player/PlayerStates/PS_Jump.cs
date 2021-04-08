using UnityEngine;
using CharacterMovement;
using VarelaAloisio.UpdateManagement.Runtime;

public class PS_Jump : StaminaConsumingState
{
	protected Transform transform;
	protected IBody body;

	protected CountDownTimer accelerationDelay;
	protected ActionOverTime accelerate;
	protected float baseSpeed;
	protected float currentSpeed;
	private float currentDrag;
	private bool isStateFinished;
	private bool accelerated;
	private LayerMask interactable;

	public PS_Jump()
	{
		StaminaPerSecond = PP_Glide.StaminaPerSecond;
		StaminaConsumptionDelay = PP_Glide.StaminaConsumptionDelay;
	}
	public override void OnStateEnter(PlayerController controller, int sceneIndex)
	{
		base.OnStateEnter(controller, sceneIndex);
		transform = controller.transform;

		currentDrag = PP_Glide.Drag;
		baseSpeed = PP_Jump.Instance.JumpSpeed;
		currentSpeed = baseSpeed;
		//	Body
		body = controller.Body;
		body.BodyEvents += BodyEventsHandler;

		interactable = LayerMask.GetMask("Interactable");
		accelerate =
			new ActionOverTime(
				PP_Glide.AccelerationTime,
				Accelerate,
				sceneIndex);
		accelerationDelay =
			new CountDownTimer(
				PP_Glide.AccelerationDelay,
				StartAcceleration,
				sceneIndex);
	}

	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.GetHorInput();

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection / 4, Color.green);

		if (HorizontalMovementHelper.IsSafeAngle(transform.position, desiredDirection.normalized, .5f,
			PP_Walk.Instance.MinSafeAngle))
		{
			Debug.DrawRay(transform.position, transform.up, Color.white);
			HorizontalMovementHelper.MoveWithRotation(transform,
				body,
				desiredDirection,
				currentSpeed,
				PP_Jump.Instance.TurnSpeedInTheAir);
		}
		else Debug.DrawRay(transform.position, transform.up, Color.black);

		ControlGlide();
		CheckForJumpBuffer();
		CheckClimb();
		Controller.RunAbilityList(Controller.AbilitiesInAir);
	}

	public override void OnStateExit()
	{
		isStateFinished = true;
		// consumeStaminaPeriod.StopTimer();
		ConsumingStamina.StopAction();
		WaitToConsumeStamina.StopTimer();
		ResetAcceleration();
		Controller.OnGlideChanges(false);
		body.BodyEvents -= BodyEventsHandler;
		body.SetDrag(0);
	}

	private void BodyEventsHandler(BodyEvent eventType)
	{
		if (eventType.Equals(BodyEvent.LAND) && FallHelper.IsGrounded)
		{
			Controller.ChangeState<PS_Walk>();
		}
	}

	private void StartAcceleration()
	{
		accelerate.StartAction();
		Controller.view.ShowAccelerationFeedback();
	}

	private void Accelerate(float lerp)
	{
		accelerated = true;
		currentSpeed = Mathf.Lerp(baseSpeed, PP_Glide.AcceleratedSpeed, BezierHelper.GetSinBezier(lerp));
		currentDrag = Mathf.Lerp(PP_Glide.Drag, PP_Glide.AcceleratedDrag,
			BezierHelper.GetSinBezier(lerp));
		Controller.view.SetAccelerationEffect(lerp);
	}

	protected virtual void ControlGlide()
	{
		if (!InputManager.GetGlideInput() || Controller.stamina.FillState < 1 || body.Velocity.y > 0)
		{
			body.SetDrag(0);
			Controller.OnGlideChanges(false);
			ConsumingStamina.StopAction();
			ResetAcceleration();
			return;
		}

		body.SetDrag(currentDrag);
		Controller.OnGlideChanges(true);
		if (!accelerationDelay.IsTicking && !accelerated)
			accelerationDelay.StartTimer();
		if (!ConsumingStamina.IsRunning && !WaitToConsumeStamina.IsTicking)
			ConsumingStamina.StartAction();
	}

	protected virtual void CheckClimb()
	{
		if (InputManager.CheckClimbInput() && Controller.stamina.FillState > 0 && ClimbHelper.CanClimb(
			transform.position,
			transform.forward,
			PP_Climb.MaxDistanceToTriggerClimb,
			PP_Climb.MaxClimbAngle,
			out _))
		{
			Controller.ChangeState<PS_Climb>();
		}
	}

	protected virtual void CheckForJumpBuffer()
	{
		if (InputManager.CheckLongJumpInput() && Physics.Raycast(transform.position, -transform.up, .5f, ~interactable))
		{
			Controller.LongJumpBuffer = true;
		}
		else if (InputManager.CheckJumpInput() &&
		         Physics.Raycast(transform.position, -transform.up, .5f, ~interactable))
		{
			Controller.JumpBuffer = true;
		}
	}

	private void ResetAcceleration()
	{
		Controller.view.StopAccelerationFeedback();
		accelerationDelay.StopTimer();
		accelerate.StopAction();
		currentDrag = PP_Glide.Drag;
		currentSpeed = baseSpeed;
		accelerated = false;
	}
}