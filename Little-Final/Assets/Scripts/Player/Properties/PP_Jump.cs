using Movement;
using Player.Properties;
using UnityEngine;
using UnityEngine.Serialization;

//TODO:Refactor these scriptables to leave the singletons behind, so the jump and longJump props can be a single class with 2 instances with different values
[CreateAssetMenu(menuName = "Properties/Player/Jump", fileName = "PP_Jump")]
public class PP_Jump : SingletonScriptable<PP_Jump>
{
	[SerializeField]
	private Vector3 force = new(0, 5.5f, 2);

	[FormerlySerializedAs("acceleration")]
	[SerializeField]
	[Range(0, 500, step: 1f)]
	private float accelerationFactor;
	
	[FormerlySerializedAs("longAcceleration")]
	[SerializeField]
	[Range(0, 500, step: 1f)]
	private float longAccelerationFactor;
	
	[FormerlySerializedAs("peakSpeed")]
	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float speed;
	
	[FormerlySerializedAs("longPeakSpeed")]
	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float longSpeed;

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
	[Range(0, 5f, step: .5f)]
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

	[Range(0, 1, 0.05f)]
	[SerializeField] private float jumpBufferDistance = .5f;

	[Header("wall awareness")]
	[SerializeField]
	[Range(0, 100, step: .25f)]
	private float awareDistance;

	[SerializeField]
	private LayerMask walls;

	[SerializeField] private StepUpConfigContainer stepUpConfig;
	[SerializeField] private bool loseItem = false;

	#region Getters

	public static Vector3 Force => Instance.force;
	public static float AccelerationFactor => Instance.accelerationFactor;
	public static float LongAccelerationFactor => Instance.longAccelerationFactor;
	public static float Speed => Instance.speed;
	public static float LongSpeed => Instance.longSpeed;
	public static float LongJumpForce => Instance.longJumpForce;
	public static float JumpSpeed => Instance.jumpSpeed;
	public static float LongJumpSpeed => Instance.longJumpSpeed;
	public static float FallMultiplier => Instance.fallMultiplier;
	public static float LowJumpMultiplier => Instance.lowJumpMultiplier;
	public static float TurnSpeedInTheAir => Instance.turnSpeedInTheAir;
	public static float TurnSpeedLongJump => Instance.turnSpeedLongJump;
	public static float CoyoteTime => Instance.coyoteTime;
	public static float LongJumpStaminaCost => Instance.longJumpStaminaCost;
	public static float JumpBufferDistance => Instance.jumpBufferDistance;
	public static float AwareDistance => Instance.awareDistance;
	public static LayerMask Walls => Instance.walls;
	public static StepUpConfigContainer StepUpConfig => Instance.stepUpConfig;
	public static bool LoseItem => Instance.loseItem;

#endregion
}