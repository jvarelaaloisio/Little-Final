using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Player/Properties/Jump")]
public class PP_Jump : ScriptableObject
{
	#region Singleton
	private static PP_Jump instance;

	public static PP_Jump Instance
	{
		get
		{
			if (!instance)
			{
				PP_Jump[] propertiesFound = Resources.LoadAll<PP_Jump>("");
				if (propertiesFound.Length >= 1) instance = propertiesFound[0];
			}
			if (!instance)
			{
				Debug.Log("No Jump Properties found in Resources folder");
				instance = CreateInstance<PP_Jump>();
			}
			return instance;
		}
	}

	#endregion

	[SerializeField]
	[Range(0, 10, step: .5f)]
	private float jumpForce,
					longJumpForce,
					jumpSpeed,
					longJumpSpeed,
					fallMultiplier,
					lowJumpMultiplier,
					glidingDrag,
					turnSpeedInTheAir,
					turnSpeedLongJump;
	[SerializeField]
	[UnityEngine.Range(0, 3)]
	private float coyoteTime;

	#region Getters
	public float JumpForce => jumpForce;
	public float LongJumpForce => longJumpForce;
	public float JumpSpeed => jumpSpeed;
	public float LongJumpSpeed => longJumpSpeed;
	public float FallMultiplier => fallMultiplier;
	public float LowJumpMultiplier => lowJumpMultiplier;
	public float GlidingDrag => glidingDrag;
	public float TurnSpeedInTheAir => turnSpeedInTheAir;
	public float TurnSpeedLongJump => turnSpeedLongJump;
	public float CoyoteTime => coyoteTime;
	#endregion
}
