using UnityEngine;

[CreateAssetMenu(menuName ="Player/Player Properties")]
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
				instance = Resources.FindObjectsOfTypeAll<PlayerProperties>()[0];
			}
			if (!instance)
			{
				instance = CreateInstance<PlayerProperties>();
			}
			return instance;
		}
	}

	#endregion

	#region Getters
	public float JumpForce { get => jumpForce; }
	public float JumpSpeed { get => jumpSpeed; }
	public float FallMultiplier { get => fallMultiplier; }
	public float LowJumpMultiplier { get => lowJumpMultiplier; }
	public float CoyoteTime { get => coyoteTime; }
	public float GlidingDrag { get => glidingDrag; }
	public float ClimbSpeed { get => climbSpeed; }
	public float TurnSpeed { get => turnSpeed; }
	#endregion

	[SerializeField]
	[Range(0, 10, step: .5f)]
	private float jumpForce,
		jumpSpeed,
		fallMultiplier,
		lowJumpMultiplier,
		coyoteTime,
		glidingDrag,
		climbSpeed,
		turnSpeed;
}
