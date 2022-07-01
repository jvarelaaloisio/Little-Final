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
			float currentSpeed = PP_Jump.LongSpeed;
			if (MoveHelper.IsApproachingWall(MyTransform,
											PP_Jump.AwareDistance,
											PP_Jump.Walls,
											out var hit))
			{
				Debug.DrawLine(MyTransform.position, hit.point, Color.blue);
				currentSpeed = Mathf.Lerp(0, PP_Jump.LongSpeed, hit.distance / PP_Jump.AwareDistance);
			}

			//TODO: Delete this and only use moveByForce once the movement tests are finished
			if (Input.GetKey(KeyCode.RightControl))
			{
				MoveHorizontally(Body, PP_Jump.LongJumpSpeed, PP_Jump.TurnSpeedLongJump);
			}
			else
			{
				//---------------------------------
				Vector2 input = InputManager.GetHorInput();
				Vector3 direction = MoveHelper.GetDirection(input);
				MoveHelper.Rotate(MyTransform, direction, PP_Jump.TurnSpeedLongJump);
				Body.RequestMovement(new MovementRequest(MyTransform.forward, currentSpeed));
				//---------------------------------
			}

			CheckForJumpBuffer();
			CheckClimb();
			Controller.RunAbilityList(Controller.AbilitiesInAir);
			CheckGlide();
		}
	}
}