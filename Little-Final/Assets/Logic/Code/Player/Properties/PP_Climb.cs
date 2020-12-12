using UnityEngine;

[CreateAssetMenu(menuName = "Properties/Player/Climb", fileName = "PP_Climb")]
public class PP_Climb : ScriptableObject
{
	#region Singleton
	private static PP_Climb instance;

	public static PP_Climb Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.Load<PP_Climb>("PP_Climb");
			}
			if (!instance)
			{
				Debug.Log("No Climb Properties found in Resources folder");
				instance = CreateInstance<PP_Climb>();
			}
			return instance;
		}
	}

	#endregion

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

	#region Getters
	public float ClimbPositioningTime => climbPositioningTime;
	public float ClimbMinTime => climbMinTime;
	public float ClimbSpeed => climbSpeed;
	public float MaxDistanceToTriggerClimb => maxDistanceToTriggerClimb;
	public float MaxClimbDistanceFromCorners => maxClimbDistanceFromCorners;
	public float MaxClimbAngle => maxClimbAngle;
	public float ClimbingPositionOffset => climbingPositionOffset;
	public float StaminaPerSecond => staminaPerSecond;
	public float StaminaConsumingDelay => staminaConsumingDelay;
	#endregion
}