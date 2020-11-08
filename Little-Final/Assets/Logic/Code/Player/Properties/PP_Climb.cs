using UnityEngine;

[CreateAssetMenu(menuName = "Properties/Player/Climb")]
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
				PP_Climb[] propertiesFound = Resources.LoadAll<PP_Climb>("");
				if (propertiesFound.Length >= 1) instance = propertiesFound[0];
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

	#region Getters
	public float ClimbPositioningTime => climbPositioningTime;
	public float ClimbMinTime => climbMinTime;
	public float ClimbSpeed => climbSpeed;
	public float MaxDistanceToTriggerClimb => maxDistanceToTriggerClimb;
	public float MaxClimbDistanceFromCorners => maxClimbDistanceFromCorners;
	public float MaxClimbAngle => maxClimbAngle;
	public float ClimbingPositionOffset => climbingPositionOffset;
	#endregion
}