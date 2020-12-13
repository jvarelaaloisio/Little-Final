using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class InputManager
{
	static readonly IPlayerInput inputReader;

	#region Constructor
	static InputManager()
	{
		//		Decide which inputReader to use
		if (SystemInfo.supportsGyroscope)
			inputReader = new MobileInput();
		else
			inputReader = new DesktopInput();
	} 
	#endregion

	public static Vector2 GetHorInput()
	{
		return inputReader.GetHorInput();
	}
	
	public static bool CheckClimbInput()
	{
		return inputReader.GetClimbInput();
	}
	public static bool CheckJumpInput()
	{
		return inputReader.GetJumpInput();
	}

	public static bool CheckLongJumpInput()
	{
		return inputReader.GetLongJumpInput();
	}
	public static bool GetGlideInput()
	{
		return inputReader.GetGlideInput();
	}
	public static bool CheckSwirlInput() => inputReader.GetSwirlInput();
	public static bool CheckPickInput()
	{
		return inputReader.GetPickInput();
	}
	public static bool CheckThrowInput()
	{
		return inputReader.GetThrowInput();
	}
}
