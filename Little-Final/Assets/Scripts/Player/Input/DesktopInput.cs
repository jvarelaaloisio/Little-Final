using System;
using UnityEngine;
public class DesktopInput : IPlayerInput
{
	public Vector2 GetHorInput()
	{
		return new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical")).normalized;
	}

	public bool GetClimbInput()
	{
		return Input.GetButton("Climb") || Input.GetAxis("Climb") == 1;
	}

	public bool GetJumpInput()
	{
		return Input.GetButtonDown("Jump");
	}
	[Obsolete]
	public bool GetLongJumpInput()
	{
		return Input.GetButtonDown("Jump") && Input.GetButton("Crouch");
	}

	public bool GetPickInput()
	{
		return Input.GetButtonDown("Pick");
	}

	public bool IsHoldingInteract()
	{
		return Input.GetButton("Interact");
	}

	public bool GetInteractInput()
	{
		return Input.GetButtonDown("Interact");
	}

	public bool GetCameraResetInput()
	{
		return Input.GetButton("ResetCamera");
	}

	public float GetCameraYInput()
	{
		return Input.GetAxis("Mouse Y");
	}

	public bool GetGlideInput()
	{
		return Input.GetButton("Jump");
	}

	public bool GetRunInput()
	{
		return Input.GetButton("Run") || Input.GetAxis("Run") == 1;
	}

	public bool GetSwirlInput()
	{
		return Input.GetButtonDown("Swirl");
	}
}