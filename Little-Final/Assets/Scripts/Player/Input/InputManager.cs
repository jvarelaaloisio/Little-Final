using System;
using System.Linq;
using UnityEngine;

namespace Player.PlayerInput
{
	[Obsolete]
	public static class InputManager
	{
		public static IPlayerInput InputReader { get; set; }
		private static Vector2 _getHorInput;

		#region Constructor
		static InputManager()
		{
			//		Decide which inputReader to use
			if (Input.GetJoystickNames().Any(name => name.Contains("Play")))
			{
				InputReader = new Ps5Input();
			}
			else
				InputReader = new DesktopInput();
		}
		#endregion

		public static Vector2 GetHorInput()
			=> InputReader.GetHorInput();

		public static float GetCameraYInput()
			=> InputReader.GetCameraYInput();
		public static bool CheckClimbInput()
			=> InputReader.GetClimbInput();

		public static bool CheckJumpInput()
			=> InputReader.GetJumpInput();

		[Obsolete]
		public static bool CheckLongJumpInput()
			=> InputReader.GetLongJumpInput();

		public static bool GetGlideInput() => InputReader.GetGlideInput();

		public static bool CheckRunInput() => InputReader.GetRunInput();
		public static bool CheckSwirlInput()
			=> InputReader.GetSwirlInput();
		public static bool CheckPickInput()
			=> InputReader.GetPickInput();

		public static bool IsHoldingInteract()
			=> InputReader.IsHoldingInteract();

		public static bool CheckInteractInput()
			=> InputReader.GetInteractInput();

		public static bool CheckCameraResetInput()
			=> InputReader.GetCameraResetInput();
	}
}
