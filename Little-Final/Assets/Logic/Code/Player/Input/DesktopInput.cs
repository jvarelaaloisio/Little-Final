using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DesktopInput : MonoBehaviour, IPlayerInput
{
	#region Public
	public Vector2 ReadHorInput()
	{
		return new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
	}

	public bool ReadClimbInput()
	{
		return Input.GetButton("Climb");
	}

	public bool ReadJumpInput()
	{
		return Input.GetButton("Jump");
	}

	public bool ReadPickInput()
	{
		return Input.GetButtonDown("Pick");
	}

	public bool ReadThrowInput()
	{
		return Input.GetButton("Throw");
	}
	#endregion
}
