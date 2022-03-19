using UnityEngine;
public class DesktopInput : IPlayerInput
{
	public Vector2 GetHorInput()
	{
		return new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
	}

	public bool GetClimbInput()
	{
		return Input.GetButton("Climb") || Input.GetAxis("Climb") == 1;
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

	public bool GetRunInput()
	{
		//TODO: Change the "Climb" key with "Run"
		return Input.GetButton("Climb") || Input.GetAxis("Climb") == 1;
	}

	public bool GetSwirlInput()
	{
		return Input.GetButtonDown("Swirl");
	}
}
