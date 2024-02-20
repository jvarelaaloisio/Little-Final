using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using CharacterMovement;
using Core.Extensions;
using Player;
using VarelaAloisio.UpdateManagement.Runtime;


[RequireComponent(typeof(Rigidbody))]
public class PlayerBody : MonoBehaviour, IBody
{
	#region Variables

	const string INTERACTABLE_LAYER = "Interactable";
	private readonly ForceRequest _invalidRequest = new ForceRequest(new Vector3(), ForceMode.Acceleration);

	#region Public

	public event BodyEvents BodyEvents;
	public Collider landCollider;

	#endregion

	#region Serialized

	[Header("Audio")]
	[SerializeField]
	AudioClip[] _soundEffects = null;

	[SerializeField]
	private float maxSpeed;

	[SerializeField]
	float _xMinAngle = 5;

	[SerializeField]
	float _xMaxAngle = 92,
		_yMinAngle = 45,
		_yMaxAngle = 90,
		_inTheAirTimeToOff = .005f,
		_colTimeToOff = 0,
		climbTimeToOff = 0.05f;

	#endregion

	#region Private

	AudioManager audioManager;

	private readonly Queue<ForceRequest> _forceRequests = new Queue<ForceRequest>();
	private readonly HashSet<ForceRequest> _constantForceRequests = new ();
	private MovementRequest _nextMovement;
	private Vector3 _jumpForce;
	private GameObject lastFloor;
	Vector3 _collisionAngles;
	public float safeDot;

	//TODO: Replace with a debug window
	private float velocityPercentage = 0;

#endregion

	#region Getters

	public Vector3 Position => transform.position;

	public Vector3 Velocity
	{
		get => RigidBody.velocity;
		set => RigidBody.velocity = value;
	}

	public GameObject GameObject => gameObject;
	public Rigidbody RigidBody { get; private set; }

	public Vector3 LastFloorNormal { get; set; }
	public float Drag
	{
		get => RigidBody.drag;
		set => RigidBody.drag = value;
	}

#endregion

	#region Setters

	public bool IsInTheAir => flags[Flag.IN_THE_AIR];

	#endregion

	#region Flags

	enum Flag
	{
		IN_THE_AIR,
		JUMP_REQUEST,
	}

	private readonly Dictionary<Flag, bool> flags = new Dictionary<Flag, bool>();

#endregion

	#endregion

	#region Unity

	private void Awake()
	{
		_nextMovement = MovementRequest.InvalidRequest;
	}

	void Start()
	{
		//TODO:Delete this
		RigidBody = GetComponent<Rigidbody>();

		SetupFlags();
	}

	private void FixedUpdate()
	{
		ControlJump();
		// if (!rb.isKinematic)
		// 	AccelerateFall();
		ProcessForceRequests();
		ProcessConstantForceRequests();
		ProcessMovementRequests();
		// if (rb.velocity.magnitude > maxSpeed)
		// 	rb.velocity = Vector3.ClampMagnitude(rb.velocity, maxSpeed);
	}

	private void ProcessMovementRequests()
	{
		if(!_nextMovement.IsValid())
			return;
		// Vector3 acceleration = (_nextMovement.GetGoalVelocity() - RigidBody.velocity).IgnoreY() * (_nextMovement.Acceleration * accelerationRate);
		velocityPercentage = Mathf.Clamp01(_nextMovement.GoalSpeed - Velocity.IgnoreY().magnitude);
		if (Velocity.IgnoreY().magnitude > _nextMovement.GoalSpeed)
		{
			return;
		}
		Vector3 acceleration = _nextMovement.Direction * _nextMovement.Acceleration;
		RigidBody.AddForce(acceleration, ForceMode.Force);
	}

	#endregion

	#region Private

	/// <summary>
	/// Processes the push requests. This method runs in the fixed update.
	/// </summary>
	private void ProcessForceRequests()
	{
		while (_forceRequests.Count > 0)
		{
			var current = _forceRequests.Dequeue();
			RigidBody.AddForce(current.Force, current.Mode);
		}
	}

	/// <summary>
	/// Processes the <see cref="_constantForceRequests"/>. This method runs on <see cref="FixedUpdate"/>
	/// </summary>
	private void ProcessConstantForceRequests()
	{
		foreach (var request in _constantForceRequests)
			RigidBody.AddForce(request.Force, request.Mode);
	}

	/// <summary>
	/// Setups the flags
	/// </summary>
	void SetupFlags()
	{
		foreach (var flag in (Flag[]) Enum.GetValues(typeof(Flag)))
		{
			flags.Add(flag, false);
		}
	}

	/// <summary>
	/// Makes the player jump
	/// </summary>
	private void ControlJump()
	{
		if (flags[Flag.JUMP_REQUEST])
		{
			flags[Flag.JUMP_REQUEST] = false;
			//Physics
			RigidBody.velocity = Vector3.zero;
			RigidBody.AddForce(_jumpForce, ForceMode.Impulse);
			//Event
			BodyEvents?.Invoke(BodyEvent.JUMP);

			//Sound
			PlaySound(0);
		}
	}

	/// <summary>
	/// Accelerates the velocity of the player while falling to eliminate feather falling effet
	/// </summary>
	public void AccelerateFall()
	{
		if (RigidBody.velocity.y < .5 && RigidBody.velocity.y > -10)
		{
			RigidBody.velocity += Vector3.up * Physics2D.gravity.y * (PP_Jump.FallMultiplier - 1) * Time.deltaTime;
		}
	}

	void PlaySound(int Index)
	{
		try
		{
			//audioManager.PlayCharacterSound(_soundEffects[Index]);
		}
		catch (NullReferenceException)
		{
			print("PBODY: AudioManager not found");
		}
	}

	#endregion

	#region Public

	/// <summary>
	/// Sets the Velocity for the Player
	/// This method overrides the velocity
	/// </summary>
	/// <param name="input"></param>
	public void MoveHorizontally(Vector3 direction, float speed)
	{
		RigidBody.velocity = direction * speed + RigidBody.velocity.y * Vector3.up;
	}

	/// <summary>
	/// This methods moves the player via Transform.position
	/// </summary>
	/// <param name="direction"></param>
	/// <param name="speed"></param>
	public void MoveByTransform(Vector3 direction, float speed) =>
		transform.position += direction * speed * Time.deltaTime;

	/// <summary>
	/// Request a jump
	/// The jump will be reproduced next fixed update
	/// </summary>
	/// <param name="jumpForce"></param>
	public void Jump(Vector3 jumpForce)
	{
		_jumpForce = jumpForce;
		flags[Flag.JUMP_REQUEST] = true;
	}

	/// <summary>
	/// Stops Characters jump to give the user more control
	/// </summary>
	public void StopJump()
	{
		RigidBody.velocity += Vector3.up * Physics2D.gravity.y * (PP_Jump.LowJumpMultiplier - 1) * Time.deltaTime;
	}

	/// <summary>
	/// Adds a push to a queue, which will be processed on the next FixedUpdate
	/// </summary>
	/// <param name="request"></param>
	public void RequestForce(ForceRequest request) => _forceRequests.Enqueue(request);
	
	/// <summary>
	/// Adds a request to the constant forces List
	/// </summary>
	/// <param name="request">This force will be applied in every fixed update, scaled by fixedDeltaTime</param>
	public void RequestConstantForce(ForceRequest request) => _constantForceRequests.Add(request);
	
	/// <summary>
	/// Removes a requests from the constant forces List
	/// </summary>
	/// <param name="request"></param>
	public void CancelConstantForce(ForceRequest request) => _constantForceRequests.Remove(request);

	/// <summary>
	/// sets the next force to add as simple movement when the fixed update runs.
	/// The body will only move with the last request added when the fixed update comes.
	/// </summary>
	/// <param name="request"></param>
	public void RequestMovementByForce(ForceRequest request)
	{
		throw new NotImplementedException();
	}

	public void RequestMovement(MovementRequest request) => _nextMovement = request;

	public void Push(Vector3 directionNormalized, float force)
	{
		Push(directionNormalized * force);
	}

	public void Push(Vector3 direction)
	{
		RigidBody.AddForce(direction, ForceMode.Impulse);
	}

	public Collider GetLandCollider()
	{
		return landCollider;
	}

	#endregion

	#region Collisions

	private void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer(INTERACTABLE_LAYER) ||
		    other.gameObject.layer == LayerMask.NameToLayer("OnlyForShadows"))
			return;
		FallHelper.AddFloor(other.gameObject);
		flags[Flag.IN_THE_AIR] = false;
		if (lastFloor != other.gameObject)
		{
			lastFloor = other.gameObject;
			Physics.Raycast(Position, -transform.up, out RaycastHit hit, 10);
			LastFloorNormal = hit.normal;
		}

		BodyEvents?.Invoke(BodyEvent.LAND);
	}

	private void OnTriggerExit(Collider other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer(INTERACTABLE_LAYER))
			return;
		FallHelper.RemoveFloor(other.gameObject);
		flags[Flag.IN_THE_AIR] = true;
		BodyEvents?.Invoke(BodyEvent.JUMP);
	}

	#endregion
}