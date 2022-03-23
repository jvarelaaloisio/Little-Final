using UnityEngine;

namespace Player.Properties
{
	[CreateAssetMenu(menuName = "Properties/Player/Glide", fileName = "PP_Glide")]
	public class PP_Glide : SingletonScriptable<PP_Glide>
	{
		[Range(0, 100, step: .5f), SerializeField]
		private float force;
		[Range(0, 100, step: .5f), SerializeField]
		private float turnSpeed;
	
		[Range(0, 100, step: .5f), SerializeField]
		private float drag,
			staminaPerSecond,
			staminaConsumptionDelay,
			timeBeforeFlight;


		#region Getters
		public static float Force => Instance.force;
		public static float TurnSpeed => Instance.turnSpeed;
		public static float Drag => Instance.drag;
		public static float StaminaPerSecond => Instance.staminaPerSecond;
		public static float StaminaConsumptionDelay => Instance.staminaConsumptionDelay;
		public static float TimeBeforeFlight => Instance.timeBeforeFlight;

		#endregion
	}
}
