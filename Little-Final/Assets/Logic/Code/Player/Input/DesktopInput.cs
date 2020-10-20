using UnityEngine;

public class DesktopInput : IPlayerInput
{
	#region Public
	public Vector2 ReadHorInput()
	{
		return new Vector2(Input.GetAxis("Horizontal"), UnityEngine.Input.GetAxis("Vertical"));
	}

	public bool ReadClimbInput()
	{
		return Input.GetButton("Climb");
	}

	public bool ReadJumpInput()
	{
		return Input.GetButtonDown("Jump");
	}
	public bool ReadLongJumpInput()
	{
		return Input.GetButtonDown("Jump") && Input.GetButton("Crouch");
	}

	public bool ReadPickInput()
	{
		return Input.GetButtonDown("Pick");
	}

	public bool ReadThrowInput()
	{
		return Input.GetButton("Throw");
	}

	public bool ReadGlideInput()
	{
		return Input.GetButton("Jump");
	}

	#endregion
}
