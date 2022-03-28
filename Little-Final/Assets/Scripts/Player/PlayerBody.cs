using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using CharacterMovement;
using Core.Extensions;
using Player;
using VarelaAloisio.UpdateManagement.Runtime;

public enum BodyEvent
{
	TRIGGER,
	JUMP,
	CLIMB,
	LAND
}

public delegate void BodyEvents(BodyEvent typeOfEvent);

[RequireComponent(typeof(Rigidbody))]
public class PlayerBody : MonoBehaviour, IFixedUpdateable, IBody
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

	Rigidbody rb;
	private readonly Queue<ForceRequest> forceRequests = new Queue<ForceRequest>();
	private ForceRequest nextMovementByForceRequest;
	private MovementRequest nextMovement;
	private Vector3 _jumpForce;
	private GameObject lastFloor;
	ContactPoint lastContact;
	Vector3 _collisionAngles;
	public float safeDot;

	#endregion

	#region Getters

	public Vector3 Position => transform.position;

	public Vector3 Velocity
	{
		get => rb.velocity;
		set => rb.velocity = value;
	}

	public GameObject GameObject => gameObject;
	public Vector3 LastFloorNormal { get; set; }

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
		nextMovementByForceRequest = _invalidRequest;
		nextMovement = MovementRequest.InvalidRequest;
	}

	void Start()
	{
		UpdateManager.Subscribe(this);
		rb = GetComponent<Rigidbody>();

		SetupFlags();
	}

	public void OnFixedUpdate()
	{
		Debug.DrawRay(transform.position, rb.velocity / 3, Color.cyan);
		ControlJump();
		AccelerateFall();
		ProcessForceRequests();
		ProcessMovementRequests();
		// if (rb.velocity.magnitude > maxSpeed)
		// 	rb.velocity = Vector3.ClampMagnitude(rb.velocity, maxSpeed);
	}

	private void ProcessMovementRequests()
	{
		if(!nextMovement.IsValid())
			return;
		// Vector3 goalVelocity = Vector3.MoveTowards(rb.velocity.IgnoreY(),
		// 											nextMovement.GetPeakVelocity(),
		// 											nextMovement.Acceleration * Time.fixedDeltaTime);
		Debug.Log(Time.fixedDeltaTime);
		Vector3 goalVelocity = Vector3.Lerp(rb.velocity.IgnoreY(),
											nextMovement.GetGoalVelocity(),
											Mathf.Clamp01(nextMovement.AccelerationFactor / 2 + Time.fixedDeltaTime * 3));
		Vector3 acceleration = (goalVelocity - rb.velocity).IgnoreY() * 10;
		rb.AddForce(acceleration, ForceMode.Force);
	}

	#endregion

	#region Private

	/// <summary>
	/// Processes the push requests. This method runs in the fixed update.
	/// </summary>
	private void ProcessForceRequests()
	{
		while (forceRequests.Count > 0)
		{
			var current = forceRequests.Dequeue();
			rb.AddForce(current.Force, current.ForceMode);
		}
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
			Vector3 newVel = rb.velocity;
			newVel.y = 0;
			// rb.velocity = newVel;
			rb.velocity = Vector3.zero;
			rb.AddForce(_jumpForce, ForceMode.Impulse);
			//Event
			BodyEvents?.Invoke(BodyEvent.JUMP);

			//Sound
			PlaySound(0);
		}
	}

	/// <summary>
	/// Accelerates the velocity of the player while falling to eliminate feather falling effet
	/// </summary>
	void AccelerateFall()
	{
		if (rb.velocity.y < .5 && rb.velocity.y > -10)
		{
			rb.velocity += Vector3.up * Physics2D.gravity.y * (PP_Jump.FallMultiplier - 1) * Time.deltaTime;
		}
	}

	public void SetDrag(float value) => rb.drag = value;

	public float GetDrag() => rb.drag;

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
		rb.velocity = direction * speed + rb.velocity.y * Vector3.up;
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
		rb.velocity += Vector3.up * Physics2D.gravity.y * (PP_Jump.LowJumpMultiplier - 1) * Time.deltaTime;
	}

	/// <summary>
	/// Adds a push to a queue, which will be processed on the next FixedUpdate
	/// </summary>
	/// <param name="request"></param>
	public void RequestForce(ForceRequest request) => forceRequests.Enqueue(request);

	/// <summary>
	/// sets the next force to add as simple movement when the fixed update runs.
	/// The body will only move with the last request added when the fixed update comes.
	/// </summary>
	/// <param name="request"></param>
	public void RequestMovementByForce(ForceRequest request) => nextMovementByForceRequest = request;
	public void RequestMovement(MovementRequest request) => nextMovement = request;

	public void Push(Vector3 directionNormalized, float force)
	{
		Push(directionNormalized * force);
	}

	public void Push(Vector3 direction)
	{
		rb.AddForce(direction, ForceMode.Impulse);
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
		else
		{
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
	}

	private void OnTriggerExit(Collider other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer(INTERACTABLE_LAYER))
			return;
		FallHelper.RemoveFloor(other.gameObject);
		flags[Flag.IN_THE_AIR] = true;
		BodyEvents?.Invoke(BodyEvent.JUMP);
	}

	private void OnCollisionStay(Collision collision)
	{
		lastContact = collision.contacts[0];
	}

	#endregion
}