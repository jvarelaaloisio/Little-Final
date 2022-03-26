using System.Collections;
using System.Collections.Generic;
using Player.Properties;
using UnityEngine;

[CreateAssetMenu(menuName = "Properties/Player/Jump", fileName = "PP_Jump")]
public class PP_Jump : SingletonScriptable<PP_Jump>
{
	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float jumpForce;

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float movementForce;

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float longJumpForce;

	[SerializeField]
	[Range(0, 50, step: 1)]
	private float longJumpStaminaCost;

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float jumpSpeed;

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float longJumpSpeed;

	[SerializeField]
	[Range(0, 2.5f, step: .5f)]
	private float fallMultiplier;

	//TODO: Revisar que hace este field
	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float lowJumpMultiplier;

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float turnSpeedInTheAir;

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float turnSpeedLongJump;

	[SerializeField]
	[UnityEngine.Range(0, 3)]
	private float coyoteTime;

	[SerializeField]
	[UnityEngine.Range(0, 3)]
	private float distanceToGround;

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
	public static float LongJumpStaminaCost => Instance.longJumpStaminaCost;

	#endregion
}