using UnityEngine;
using CharacterMovement;
public class PS_LongJump : PS_Jump
{
	public override void OnStateEnter(PlayerModel model)
	{
		base.OnStateEnter(model);
		baseSpeed = PP_Jump.Instance.LongJumpSpeed;
	}
	public override void OnStateUpdate()
	{
		Vector2 input = InputManager.GetHorInput();

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection / 4, Color.green);

		if (HorizontalMovementHelper.IsSafeAngle(transform.position, desiredDirection.normalized, .5f, PP_Walk.Instance.MinSafeAngle))
		{
			HorizontalMovementHelper.MoveWithRotation(
														transform,
														body,
														desiredDirection,
														currentSpeed,
														PP_Jump.Instance.TurnSpeedLongJump);
		}

		ControlGlide();
		CheckForJumpBuffer();
		CheckClimb();
		model.RunAbilityList(model.AbilitiesInAir);
	}
}
