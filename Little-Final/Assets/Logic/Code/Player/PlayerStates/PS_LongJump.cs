using UnityEngine;
using CharacterMovement;
public class PS_LongJump : PS_Jump
{
	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.ReadHorInput();

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection / 4, Color.green);

		if (HorizontalMovementHelper.IsSafeAngle(transform.position, desiredDirection.normalized, .5f, PP_Walk.Instance.MinSafeAngle))
		{
			HorizontalMovementHelper.MoveWithRotation(
														transform,
														body,
														desiredDirection,
														PP_Jump.Instance.LongJumpSpeed,
														PP_Jump.Instance.TurnSpeedLongJump);
		}

		ControlGlide();
		CheckForJumpBuffer();
		CheckClimb();
	}
}
