using System.Collections;
using System.Collections.Generic;
using Player.Properties;
using UnityEngine;

[CreateAssetMenu(menuName = "Properties/Player/Jump", fileName = "PP_Jump")]
public class PP_Jump : SingletonScriptable<PP_Jump>
{
	[SerializeField] [Range(0, 100, step: .5f)]
	private float jumpForce;
	[SerializeField] [Range(0, 100, step: .5f)]
	private float movementForce,
		longJumpForce,
		jumpSpeed,
		longJumpSpeed,
		fallMultiplier,
		lowJumpMultiplier,
		turnSpeedInTheAir,
		turnSpeedLongJump;

	[SerializeField] [UnityEngine.Range(0, 3)]
	private float coyoteTime,
		distanceToGround;

	#region Getters

	public static float JumpForce => Instance.jumpForce;
	public static float MovementForce => Instance.movementForce;
	public static float LongJumpForce => Instance.longJumpForce;
	public static float JumpSpeed => Instance.jumpSpeed;
	public static float LongJumpSpeed => Instance.longJumpSpeed;
	public static float FallMultiplier => Instance.fallMultiplier;
	public static float LowJumpMultiplier => Instance.lowJumpMultiplier;
	public static float TurnSpeedInTheAir => Instance.turnSpeedInTheAir;
	public static float TurnSpeedLongJump => Instance.turnSpeedLongJump;
	public static float CoyoteTime => Instance.coyoteTime;
	public static float DistanceToGround => Instance.distanceToGround;

	#endregion
}