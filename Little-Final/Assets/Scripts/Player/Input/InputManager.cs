using UnityEngine;

namespace Player.PlayerInput
{
	public static class InputManager
	{
		private static readonly IPlayerInput InputReader;
		private static Vector2 _getHorInput;

		#region Constructor
		static InputManager()
		{
			//		Decide which inputReader to use
			if (SystemInfo.supportsGyroscope)
				InputReader = new MobileInput();
			else
				InputReader = new DesktopInput();
		} 
		#endregion

		public static Vector2 GetHorInput()
			=> InputReader.GetHorInput();

		public static bool CheckClimbInput()
			=> InputReader.GetClimbInput();

		public static bool CheckJumpInput()
			=> InputReader.GetJumpInput();

		public static bool CheckLongJumpInput()
			=> InputReader.GetLongJumpInput();

		public static bool GetGlideInput() => InputReader.GetGlideInput();

		public static bool CheckRunInput() => InputReader.GetRunInput();
		public static bool CheckSwirlInput()
			=> InputReader.GetSwirlInput();
		public static bool CheckPickInput()
			=> InputReader.GetPickInput();

		public static bool CheckThrowInput()
			=> InputReader.GetThrowInput();
	}
}
