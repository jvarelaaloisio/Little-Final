using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName ="Player/Player_Vars")]
public class Player_Properties_SO : ScriptableObject
{
	#region Singleton
	private static Player_Properties_SO instance;

	public static Player_Properties_SO Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.FindObjectsOfTypeAll<Player_Properties_SO>()[0];
			}
			if (!instance)
			{
				instance = CreateInstance<Player_Properties_SO>();
			}
			return instance;
		}
	}

	#endregion

	#region Getters
	public float JumpForce { get => jumpForce; set => jumpForce = value; }
	public float JumpSpeed { get => jumpSpeed; set => jumpSpeed = value; }
	public float FallMultiplier { get => fallMultiplier; set => fallMultiplier = value; }
	public float LowJumpMultiplier { get => lowJumpMultiplier; set => lowJumpMultiplier = value; }
	public float CoyoteTime { get => coyoteTime; set => coyoteTime = value; }
	public float GlidingDrag { get => glidingDrag; set => glidingDrag = value; }
	public float ClimbSpeed { get => climbSpeed; set => climbSpeed = value; }
	public float TurnSpeed { get => turnSpeed; set => turnSpeed = value; }
	#endregion

	[SerializeField]
	[Range(0, 10)]
	private float jumpForce,
		jumpSpeed,
		fallMultiplier,
		lowJumpMultiplier,
		coyoteTime,
		glidingDrag,
		climbSpeed,
		turnSpeed;
}
