using UnityEngine;
[CreateAssetMenu(menuName = "Player/Player Properties")]
public class PlayerProperties : ScriptableObject
{
	#region Singleton
	private static PlayerProperties instance;

	public static PlayerProperties Instance
	{
		get
		{
			if (!instance)
			{
				PlayerProperties[] propertiesFound = Resources.LoadAll<PlayerProperties>("");
				if (propertiesFound.Length >= 1) instance = propertiesFound[0];
			}
			if (!instance)
			{
				Debug.Log("No PlayerProperties found in Resources folder");
				instance = CreateInstance<PlayerProperties>();
			}
			return instance;
		}
	}

	#endregion

	#region Getters
	public float Speed => speed;
	public float JumpForce => jumpForce;
	public float JumpSpeed => jumpSpeed;
	public float LongJumpSpeed => longJumpSpeed;
	public float LandColliderDelay => landColliderEnableDelay;
	public float FallMultiplier => fallMultiplier;
	public float LowJumpMultiplier => lowJumpMultiplier;
	public float CoyoteTime => coyoteTime;
	public float GlidingDrag => glidingDrag;
	public float ClimbSpeed => climbSpeed;
	public float TurnSpeed => turnSpeed;
	public float TurnSpeedInTheAir => turnSpeedInTheAir;
	public float TurnSpeedLongJump => turnSpeedLongJump;
	#endregion

	[SerializeField]
	[Range(0, 10, step: .5f)]
	private float speed,
		jumpForce,
		jumpSpeed,
		longJumpSpeed,
		fallMultiplier,
		lowJumpMultiplier,
		glidingDrag,
		climbSpeed,
		turnSpeed,
		turnSpeedInTheAir,
		turnSpeedLongJump;
	[SerializeField]
	[UnityEngine.Range(0, 3)]
	private float coyoteTime,
		landColliderEnableDelay;
}