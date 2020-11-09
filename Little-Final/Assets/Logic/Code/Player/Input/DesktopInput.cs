using UnityEngine;

public class DesktopInput : IPlayerInput
{
	#region Public
	public Vector2 GetHorInput()
	{
		return new Vector2(Input.GetAxis("Horizontal"), UnityEngine.Input.GetAxis("Vertical"));
	}

	public bool GetClimbInput()
	{
		return Input.GetButton("Climb");
	}

	public bool GetJumpInput()
	{
		return Input.GetButtonDown("Jump");
	}
	public bool GetLongJumpInput()
	{
		return Input.GetButtonDown("Jump") && Input.GetButton("Crouch");
	}

	public bool GetPickInput()
	{
		return Input.GetButtonDown("Pick");
	}

	public bool GetThrowInput()
	{
		return Input.GetButton("Throw");
	}

	public bool GetGlideInput()
	{
		return Input.GetButton("Jump");
	}
	#endregion
}
