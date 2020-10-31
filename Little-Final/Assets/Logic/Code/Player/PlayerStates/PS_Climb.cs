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
	public PS_Climb()
	{
		positioningAction = new ActionOverTime(PP_Climb.Instance.ClimbPositioningTime, GetInPosition, true);
		CliffClimbingTimer = new CountDownTimer(PP_Climb.Instance.ClimbPositioningTime, () => brain.ChangeState<PS_Jump>());
	}
	public override void OnStateEnter(Player_Brain brain)
	{
		base.OnStateEnter(brain);
		body = brain.Body;
		brain.GetComponent<Rigidbody>().isKinematic = true;
		transform = brain.transform;

		ClimbHelper.CanClimb(transform.position,
								transform.forward,
								PP_Climb.Instance.MaxDistanceToTriggerClimb,
								PP_Climb.Instance.MaxClimbAngle,
								out RaycastHit hit);
		ResetPosition(hit);
		positioningAction.StartAction();
	}
	public override void OnStateUpdate()
	{
		if (!isInPosition)
			return;
		Vector2 input = InputManager.ReadHorInput();
		Vector3 moveDirection = transform.right * input.x + transform.up * input.y;

		if (IsTouchingGround() && moveDirection.y < 0)
			moveDirection.y = 0;

		RaycastHit hit;
		if (ClimbHelper.CanMove(transform.position,
							transform.forward,
							moveDirection.normalized,
							PP_Climb.Instance.MaxClimbDistanceFromCorners,
							PP_Climb.Instance.MaxDistanceToTriggerClimb,
							PP_Climb.Instance.MaxClimbAngle,
							out hit))
		{
			if (!hit.transform.Equals(currentWall))
			{
				ResetPosition(hit);
			}
			body.Move(moveDirection, PP_Climb.Instance.ClimbSpeed);
			Physics.Raycast(transform.position, transform.forward, out RaycastHit forwardHit, PP_Climb.Instance.MaxDistanceToTriggerClimb, LayerMask.GetMask("Climbable"));
			transform.rotation = Quaternion.LookRotation(-forwardHit.normal);
			Debug.DrawLine(transform.position, hit.point, Color.yellow);
		}
		else
		{
			if (Vector3.Dot(moveDirection, transform.up) == 1
				&&
				ClimbHelper.CanClimbUp(transform.position, transform.up, transform.forward, PP_Climb.Instance.MaxClimbDistanceFromCorners, PP_Climb.Instance.MaxDistanceToTriggerClimb, out RaycastHit cliffHit))
			{
				Debug.DrawRay(cliffHit.point, cliffHit.normal / 4, Color.blue, 2);
				GetOverCliff(cliffHit);
			}
		}

		if (!InputManager.ReadClimbInput())
		{
			brain.ChangeState<PS_Jump>();
		}
	}
	public override void OnStateExit()
	{
		base.OnStateExit();
		brain.GetComponent<Rigidbody>().isKinematic = false;
		Quaternion newRotation = Quaternion.identity;
		newRotation.y = transform.rotation.y;
		transform.rotation = newRotation;
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