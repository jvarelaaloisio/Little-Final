using UnityEngine;
using CharacterMovement;
using VarelaAloisio.UpdateManagement.Runtime;

public class PS_Jump : PlayerState
{
	protected Transform transform;
	protected IBody body;

	protected CountDownTimer consumeStaminaPeriod,
		staminaConsumptiongDelay;

	protected CountDownTimer accelerationDelay;
	protected ActionOverTime accelerate;
	protected float baseSpeed;
	protected float currentSpeed;
	private float currentDrag;
	private bool isStateFinished;
	private bool accelerated;
	private LayerMask interactable;

	public override void OnStateEnter(PlayerModel model, int sceneIndex)
	{
		base.OnStateEnter(model, sceneIndex);
		transform = model.transform;

		currentDrag = PP_Glide.Instance.Drag;
		baseSpeed = PP_Jump.Instance.JumpSpeed;
		currentSpeed = baseSpeed;
		//	Body
		body = model.Body;
		body.BodyEvents += BodyEventsHandler;

		interactable = LayerMask.GetMask("Interactable");

		consumeStaminaPeriod =
			new CountDownTimer(
			1 / PP_Glide.Instance.StaminaPerSecond,
			ConsumeStamina,
			sceneIndex);
		staminaConsumptiongDelay =
			new CountDownTimer(
				PP_Glide.Instance.StaminaConsumptionDelay,
				null,
				sceneIndex);

		accelerate =
			new ActionOverTime(
			PP_Glide.Instance.AccelerationTime,
			Accelerate,
			sceneIndex);
		accelerationDelay =
			new CountDownTimer(
			PP_Glide.Instance.AccelerationDelay,
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
		Model.RunAbilityList(Model.AbilitiesInAir);
	}

	public override void OnStateExit()
	{
		isStateFinished = true;
		consumeStaminaPeriod.StopTimer();
		staminaConsumptiongDelay.StopTimer();
		ResetAcceleration();
		Model.view.SetFlying(false);
		body.BodyEvents -= BodyEventsHandler;
		body.SetDrag(0);
	}

	private void BodyEventsHandler(BodyEvent eventType)
	{
		if (eventType.Equals(BodyEvent.LAND) && FallHelper.IsGrounded)
		{
			Model.ChangeState<PS_Walk>();
		}
	}

	private void StartAcceleration()
	{
		accelerate.StartAction();
		Model.view.ShowAccelerationFeedback();
	}

	private void Accelerate(float lerp)
	{
		accelerated = true;
		currentSpeed = Mathf.Lerp(baseSpeed, PP_Glide.Instance.AcceleratedSpeed, BezierHelper.GetSinBezier(lerp));
		currentDrag = Mathf.Lerp(PP_Glide.Instance.Drag, PP_Glide.Instance.AcceleratedDrag,
			BezierHelper.GetSinBezier(lerp));
		Model.view.SetAccelerationEffect(lerp);
	}

	protected virtual void ControlGlide()
	{
		if (!InputManager.GetGlideInput() || Model.stamina.FillState < 1 || body.Velocity.y > 0)
		{
			body.SetDrag(0);
			Model.view.SetFlying(false);
			consumeStaminaPeriod.StopTimer();
			ResetAcceleration();
			return;
		}

		body.SetDrag(currentDrag);
		Model.view.SetFlying(true);
		if (!accelerationDelay.IsTicking && !accelerated)
			accelerationDelay.StartTimer();
		if (!consumeStaminaPeriod.IsTicking && !staminaConsumptiongDelay.IsTicking)
			consumeStaminaPeriod.StartTimer();
	}

	protected virtual void CheckClimb()
	{
		if (InputManager.CheckClimbInput() && Model.stamina.FillState > 0 && ClimbHelper.CanClimb(transform.position,
			transform.forward,
			PP_Climb.Instance.MaxDistanceToTriggerClimb,
			PP_Climb.Instance.MaxClimbAngle,
			out _))
		{
			Model.ChangeState<PS_Climb>();
		}
	}

	protected virtual void CheckForJumpBuffer()
	{
		if (InputManager.CheckLongJumpInput() && Physics.Raycast(transform.position, -transform.up, .5f, ~interactable))
		{
			Model.LongJumpBuffer = true;
		}
		else if (InputManager.CheckJumpInput() &&
		         Physics.Raycast(transform.position, -transform.up, .5f, ~interactable))
		{
			Model.JumpBuffer = true;
		}
	}

	protected void ConsumeStamina()
	{
		Model.stamina.ConsumeStamina(1);
		if (!isStateFinished)
			consumeStaminaPeriod.StartTimer();
	}


	private void ResetAcceleration()
	{
		Model.view.StopAccelerationFeedback();
		accelerationDelay.StopTimer();
		accelerate.StopAction();
		currentDrag = PP_Glide.Instance.Drag;
		currentSpeed = baseSpeed;
		accelerated = false;
	}
}