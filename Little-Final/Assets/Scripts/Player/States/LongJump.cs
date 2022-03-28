using System;
using CharacterMovement;
using Player.PlayerInput;
using UnityEngine;

namespace Player.States
{
	[Obsolete]
	public class LongJump : Jump
	{
		public override void OnStateUpdate()
		{
			//TODO: Delete this and only use moveByForce once the movement tests are finished
			if (Input.GetKey(KeyCode.RightControl))
			{
				MoveHorizontally(Body, PP_Jump.LongJumpSpeed, PP_Jump.TurnSpeedLongJump);
			}
			else
			{
				//---------------------------------
				Vector2 input = InputManager.GetHorInput();
				Vector3 direction = HorizontalMovementHelper.GetDirection(input);
				HorizontalMovementHelper.Rotate(MyTransform, direction, PP_Jump.TurnSpeedLongJump);
				Body.RequestMovement(new MovementRequest(MyTransform.forward, PP_Jump.LongAccelerationFactor, PP_Jump.LongSpeed));
				//---------------------------------
			}

			CheckForJumpBuffer();
			CheckClimb();
			Controller.RunAbilityList(Controller.AbilitiesInAir);
			CheckGlide();
		}
	}
}