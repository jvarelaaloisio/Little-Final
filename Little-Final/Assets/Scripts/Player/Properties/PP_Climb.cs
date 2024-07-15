using UnityEngine;

namespace Player.Properties
{
	[CreateAssetMenu(menuName = "Properties/Player/Climb", fileName = "PP_Climb")]
	public class PP_Climb : SingletonScriptable<PP_Climb>
	{
		[SerializeField]
		[Range(0, 10, step: .5f)]
		private float climbSpeed;
		[SerializeField]
		[UnityEngine.Range(0, 3)]
		private float climbPositioningTime,
			climbMinTime;
		[SerializeField]
		[UnityEngine.Range(0, 5)]
		private float climbingPositionOffset,
			maxDistanceToTriggerClimb,
			maxClimbDistanceFromCorners;
		[SerializeField]
		[Range(0, 60, step: 1)]
		private float maxClimbAngle;
		[SerializeField]
		[Range(0, 20, step: 1)]
		private float staminaPerSecond;
		[SerializeField]
		[Range(0, 10, step: .2f)]
		private float staminaConsumingDelay;

		[SerializeField]
		private float rotationSpeed = 1;


	#region Getters
		public static float ClimbPositioningTime => Instance.climbPositioningTime;
		public static float ClimbMinTime => Instance.climbMinTime;
		public static float ClimbSpeed => Instance.climbSpeed;
		public static float MaxDistanceToTriggerClimb => Instance.maxDistanceToTriggerClimb;
		public static float MaxClimbDistanceFromCorners => Instance.maxClimbDistanceFromCorners;
		public static float MaxClimbAngle => Instance.maxClimbAngle;
		public static float ClimbingPositionOffset => Instance.climbingPositionOffset;
		public static float StaminaPerSecond => Instance.staminaPerSecond;
		public static float StaminaConsumingDelay => Instance.staminaConsumingDelay;

		public static float RotationSpeed => Instance.rotationSpeed;

	#endregion
	}
}