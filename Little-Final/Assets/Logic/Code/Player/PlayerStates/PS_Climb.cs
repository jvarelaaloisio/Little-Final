using CharacterMovement;
using UnityEngine;
using UpdateManagement;

public class PS_Climb : PlayerState
{
	private IBody body;
	private bool isInPosition;
	private Vector3 originPosition,
			targetPosition;
	private Quaternion originRotation,
			targetRotation;
	private readonly ActionOverTime positioningAction;
	private readonly CountDownTimer CliffClimbingTimer;
	private Transform transform;
	private Transform currentWall;
	protected CountDownTimer consumeStaminaPeriod,
		staminaConsumingDelay;
	private bool isClimbFinished;
	public PS_Climb()
	{
		positioningAction = new ActionOverTime(PP_Climb.Instance.ClimbPositioningTime, GetInPosition, true);
		CliffClimbingTimer = new CountDownTimer(PP_Climb.Instance.ClimbPositioningTime, () => model.ChangeState<PS_Jump>());

		consumeStaminaPeriod = new CountDownTimer(1 / PP_Climb.Instance.StaminaPerSecond, ConsumeStamina);
		staminaConsumingDelay = new CountDownTimer(PP_Climb.Instance.StaminaConsumingDelay, consumeStaminaPeriod.StartTimer);
	}
	public override void OnStateEnter(PlayerModel model)
	{
		base.OnStateEnter(model);
		transform = model.transform;
		body = model.Body;

		if (model.stamina.FillState < 1)
		{
			model.ChangeState<PS_Jump>();
			return;
		}
		model.stamina.StopFilling();

		model.view.ShowClimbFeedback();
		model.GetComponent<Rigidbody>().isKinematic = true;

		ClimbHelper.CanClimb(transform.position,
								transform.forward,
								PP_Climb.Instance.MaxDistanceToTriggerClimb,
								PP_Climb.Instance.MaxClimbAngle,
								out RaycastHit hit);
		ResetPosition(hit);
		positioningAction.StartAction();
		staminaConsumingDelay.StartTimer();
	}
	public override void OnStateUpdate()
	{
		if (!isInPosition)
			return;
		Vector2 input = InputManager.GetHorInput();
		Vector3 moveDirection = transform.right * input.x + transform.up * input.y;

		if (IsTouchingGround() && moveDirection.y < 0)
			moveDirection.y = 0;

		//Move
		if (moveDirection.magnitude != 0 && ClimbHelper.CanMove(transform.position,
				transform.forward,
				moveDirection.normalized,
				PP_Climb.Instance.MaxClimbDistanceFromCorners,
				PP_Climb.Instance.MaxDistanceToTriggerClimb,
				PP_Climb.Instance.MaxClimbAngle,
				out RaycastHit hit))
		{
			if (!hit.transform.Equals(currentWall))
			{
				ResetPosition(hit);
			}
			else
			{
				if (!consumeStaminaPeriod.IsTicking)
					consumeStaminaPeriod.StartTimer();
				body.Move(moveDirection, PP_Climb.Instance.ClimbSpeed);
				//Rotation
				Physics.Raycast(transform.position, transform.forward, out RaycastHit forwardHit, PP_Climb.Instance.MaxDistanceToTriggerClimb, ~LayerMask.GetMask("NonClimbable"));
				transform.rotation = Quaternion.LookRotation(-forwardHit.normal);
				Debug.DrawLine(transform.position, hit.point, Color.yellow);
			}
		}
		//Cliff
		else if (Mathf.Approximately(Vector3.Dot(moveDirection, transform.up), 1)
				&&
				ClimbHelper.CanClimbUp(transform.position, transform.up, transform.forward, PP_Climb.Instance.MaxClimbDistanceFromCorners, PP_Climb.Instance.MaxDistanceToTriggerClimb, out RaycastHit cliffHit))
		{
			Debug.DrawRay(cliffHit.point, cliffHit.normal / 4, Color.blue, 2);
			GetOverCliff(cliffHit);
		}
		//Stop
		else
		{
			consumeStaminaPeriod.StopTimer();
		}

		if (!InputManager.CheckClimbInput() || model.stamina.FillState < 1)
		{
			model.ChangeState<PS_Jump>();
		}

		model.RunAbilityList(model.AbilitiesOnWall);
	}
	public override void OnStateExit()
	{
		base.OnStateExit();
		isClimbFinished = true;
		positioningAction.StopAction();
		consumeStaminaPeriod.StopTimer();
		staminaConsumingDelay.StopTimer();
		model.stamina.ResumeFilling();
		model.GetComponent<Rigidbody>().isKinematic = false;
		Quaternion newRotation = Quaternion.identity;
		newRotation.y = transform.rotation.y;
		transform.rotation = newRotation;
	}

	protected void ConsumeStamina()
	{
		model.stamina.ConsumeStamina(1);
		if (isClimbFinished)
			return;
		consumeStaminaPeriod.StartTimer();
	}

	private void ResetPosition(RaycastHit hit)
	{
		originPosition = transform.position;
		originRotation = transform.rotation;

		targetRotation = Quaternion.LookRotation(-hit.normal);
		targetPosition = hit.point - transform.forward * PP_Climb.Instance.ClimbingPositionOffset;

		currentWall = hit.transform;

		isInPosition = false;
		positioningAction.StartAction();
	}

	private void GetOverCliff(RaycastHit hit)
	{
		originPosition = transform.position;
		originRotation = transform.rotation;
		targetPosition = hit.point + (transform.up * transform.localScale.y / 5);
		targetRotation = transform.rotation;

		isInPosition = false;
		positioningAction.StartAction();
		CliffClimbingTimer.StartTimer();
	}

	private void GetInPosition(float bezier)
	{
		transform.position = Vector3.Lerp(originPosition, targetPosition, bezier);
		transform.rotation = Quaternion.Slerp(originRotation, targetRotation, bezier);
		if (bezier == 1)
		{
			isInPosition = true;
		}
	}

	private bool IsTouchingGround()
	{
		if (Physics.Raycast(transform.position,
							Vector3.down,
							PP_Climb.Instance.MaxClimbDistanceFromCorners,
							LayerMask.GetMask("default", "Floor")))
		{
			Debug.DrawRay(transform.position, Vector3.down * PP_Climb.Instance.MaxClimbDistanceFromCorners, Color.green);
			return true;
		}
		return false;
	}

}