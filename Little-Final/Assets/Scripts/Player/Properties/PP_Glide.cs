using Player.Movement;
using UnityEngine;
using UnityEngine.Serialization;

namespace Player.Properties
{
	[CreateAssetMenu(menuName = "Properties/Player/Glide", fileName = "PP_Glide")]
	public class PP_Glide : SingletonScriptable<PP_Glide>
	{
		[Range(0, 50, step: .5f)]
		[SerializeField]
		private float acceleration;
	
		[SerializeField]
		[Range(0, 50, step: .5f)]
		private float speed;

		[Range(0, 50, step: .5f)]
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

		[Range(0, 2)]
		[SerializeField]
		private float gravityMultiplier = .5f;

		[SerializeField] private StepUpConfigContainer stepUpConfig;

	#region Getters
		public static float Acceleration => Instance.acceleration;
		public static float Speed => Instance.speed;
		public static float TurnSpeed => Instance.turnSpeed;
		public static float Drag => Instance.drag;
		public static float StaminaPerSecond => Instance.staminaPerSecond;
		public static float StaminaConsumptionDelay => Instance.staminaConsumptionDelay;
		public static float TimeBeforeFlight => Instance.timeBeforeFlight;
		public static float GravityMultiplier => Instance.gravityMultiplier;
		public static StepUpConfigContainer StepUpConfig => Instance.stepUpConfig;

	#endregion
	}
}
