using UnityEngine;

namespace Player.Properties
{
	[CreateAssetMenu(menuName = "Properties/Player/Fly", fileName = "PP_Fly")]
	public class PP_Fly : SingletonScriptable<PP_Fly>
	{
		[Range(0, 200, step: 1f), SerializeField]
		private float force;
		[Range(0, 100, step: .5f), SerializeField]
		private float turnSpeed;

		[Range(0, 100, step: .5f), SerializeField]
		private float drag;
		[Range(0, 100, step: .5f), SerializeField]
		private float staminaPerSecond;
		[Range(0, 100, step: .5f), SerializeField]
		private float staminaConsumptionDelay;
		[Range(0, 100, step: .5f), SerializeField]
		private float accelerationTime;

		#region Getters
		public static float Force => Instance.force;
		public static float TurnSpeed => Instance.turnSpeed;
		public static float Drag => Instance.drag;
		public static float StaminaPerSecond => Instance.staminaPerSecond;
		public static float StaminaConsumptionDelay => Instance.staminaConsumptionDelay;
		public static float AccelerationTime => Instance.accelerationTime;

		#endregion
	}
}