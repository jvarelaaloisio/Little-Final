using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PS_LongJump : PS_Jump
{
	public override void OnStateUpdate()
	{
		//		Read Input
		Vector2 input = InputManager.ReadHorInput();

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection, Color.green);

		HorizontalMovementHelper.moveWithRotation(transform,
											body,
											desiredDirection,
											PlayerProperties.Instance.LongJumpSpeed,
											PlayerProperties.Instance.TurnSpeedLongJump);
		ReadInput();
	}
}
