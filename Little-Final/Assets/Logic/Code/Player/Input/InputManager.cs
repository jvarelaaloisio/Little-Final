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

	public static Vector2 ReadHorInput()
	{
		return inputReader.ReadHorInput();
	}
	
	public static bool ReadClimbInput()
	{
		return inputReader.ReadClimbInput();
	}
	public static bool ReadJumpInput()
	{
		return inputReader.ReadJumpInput();
	}

	public static bool ReadLongJumpInput()
	{
		return inputReader.ReadLongJumpInput();
	}
	public static bool ReadGlideInput()
	{
		return inputReader.ReadGlideInput();
	}
	public static bool ReadPickInput()
	{
		return inputReader.ReadPickInput();
	}
	public static bool ReadThrowInput()
	{
		return inputReader.ReadThrowInput();
	}
}
