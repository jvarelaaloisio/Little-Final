using UnityEngine;
using UnityEngine.Serialization;

namespace Player.Properties
{
	[CreateAssetMenu(menuName = "Properties/Player/Glide", fileName = "PP_Glide")]
	public class PP_Glide : SingletonScriptable<PP_Glide>
	{
		[FormerlySerializedAs("acceleration")]
		[Range(0, 500, step: .5f)]
		[SerializeField]
		private float accelerationFactor;
	
		[FormerlySerializedAs("peakSpeed")]
		[SerializeField]
		[Range(0, 100, step: .5f)]
		private float speed;

		[Range(0, 100, step: .5f)]
		[SerializeField]
		private float turnSpeed;

		[Range(0, 100, step: .5f)]
		[SerializeField]
		private float drag;

		[Range(0, 100, step: .5f)]
		[SerializeField]
		private float staminaPerSecond;

		[Range(0, 100, step: .5f)]
		[SerializeField]
		private float staminaConsumptionDelay;

		[Range(0, 100, step: .5f)]
		[SerializeField]
		private float timeBeforeFlight;


		#region Getters
		public static float AccelerationFactor => Instance.accelerationFactor;
		public static float Speed => Instance.speed;
		public static float TurnSpeed => Instance.turnSpeed;
		public static float Drag => Instance.drag;
		public static float StaminaPerSecond => Instance.staminaPerSecond;
		public static float StaminaConsumptionDelay => Instance.staminaConsumptionDelay;
		public static float TimeBeforeFlight => Instance.timeBeforeFlight;

		#endregion
	}
}
