using System;
using System.Collections.Generic;
using UnityEngine;

public enum BodyEvent
{
	TRIGGER,
	JUMP,
	CLIMB,
	LAND
}

public delegate void BodyEvents(BodyEvent typeOfEvent);
[RequireComponent(typeof(Rigidbody))]
public class Player_Body : MonoBehaviour, IUpdateable, IBody
{
	#region Variables

	public SO_Layer climbableTopLayer;

	#region Public
	public event BodyEvents BodyEvents;
	public Transform lastClimbable;
	public Collider landCollider;
	#endregion

	#region Serialized
	[Header("Movement")]
	[SerializeField]
	float Speed = 4;

	[Header("Audio")]
	[SerializeField]
	AudioClip[] _soundEffects = null;

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

	UpdateManager updateManager;
	AudioManager audioManager;

	Rigidbody rb;
	Timer _colTimer, _coyoteTimer, _jumpTimer, _climbTimer;

	ContactPoint lastContact;
	Vector3 _collisionAngles;
	float JumpingAccelerationFactor => flags[Flag.IN_THE_AIR] ? PlayerProperties.Instance.JumpSpeed : 1;
	#endregion

	#region Getters
	public Vector3 Position
	{
		get
		{
			return transform.position;
		}
	}
	public Vector3 Velocity
	{
		get
		{
			return rb.velocity;
		}
	}

	#endregion

	#region Setters
	public bool IsInTheAir
	{
		get
		{
			return flags[Flag.IN_THE_AIR];
		}
		/*set
		{
			if (!value)
			{
				if (flags[Flag.IN_THE_AIR])
				{
					//Event
					BodyEvents?.Invoke(BodyEvent.LAND);
					flags[Flag.IN_THE_AIR] = false;
				}
				if (flags[Flag.IN_COYOTE_TIME])
				{
					_coyoteTimer.Stop();
					flags[Flag.IN_COYOTE_TIME] = false;
				}
				TurnGlide(false);
			}
			else if (!flags[Flag.IN_COYOTE_TIME] && !flags[Flag.IN_THE_AIR] && !flags[Flag.CLIMBING])
			{
				_coyoteTimer.Play();
				flags[Flag.IN_COYOTE_TIME] = true;
			}
		}*/
	}
	public bool CollidingWithClimbable
	{
		set
		{
			flags[Flag.TOUCHING_CLIMBABLE] = value;
		}
	}
	public bool CollidingWithClimbableTopSolid
	{
		set
		{
			flags[Flag.TOUCHING_CLIMBABLE_TOP_SOLID] = value;
		}
	}

	public bool CollidingWithPickable
	{
		get
		{
			return flags[Flag.TOUCHING_PICKABLE];
		}
		set
		{
			flags[Flag.TOUCHING_PICKABLE] = value;
		}
	}
	public bool InputClimb
	{
		set
		{
			flags[Flag.CLIMB_REQUEST] = value;
		}
	}
	public bool InputJump
	{
		set
		{
			flags[Flag.JUMP_REQUEST] = true;
		}
	}
	public bool InputGlide
	{
		set
		{
			flags[Flag.GLIDE_REQUEST] = value;
		}
	}
	public float flash
	{
		set
		{
			Speed *= value;
		}
	}
	#endregion

	#region Flags
	enum Flag
	{
		IN_THE_AIR,
		JUMP_REQUEST,
		GLIDE_REQUEST,
		CLIMB_REQUEST,
		GLIDING,
		CLIMBING,
		COLLIDING,
		TOUCHING_PICKABLE,
		TOUCHING_CLIMBABLE,
		TOUCHING_CLIMBABLE_TOP_SOLID,
		COL_COUNTING,
		WEIRD_COL_COUNTING,
		IN_COYOTE_TIME
	}

	private readonly Dictionary<Flag, bool> flags = new Dictionary<Flag, bool>();

	#endregion


	#endregion

	#region Unity
	void Start()
	{
		try
		{
			updateManager = GameObject.FindObjectOfType<UpdateManager>();
			updateManager.AddFixedItem(this);
		}
		catch (NullReferenceException)
		{
			print(this.name + "update manager not found");
		}
		rb = GetComponent<Rigidbody>();

		SetupFlags();
	}
	public void OnUpdate()
	{
		ControlJump();
		ControlClimb();
		AccelerateFall();
	}
	#endregion

	#region Private
	/// <summary>
	/// Setups the flags
	/// </summary>
	void SetupFlags()
	{
		foreach (var flag in (Flag[])Enum.GetValues(typeof(Flag)))
		{
			flags.Add(flag, false);
		}
	}


	/// <summary>
	/// Event Handler for the timers
	/// </summary>
	void TimerFinishedHandler(string ID)
	{
		switch (ID)
		{
			case "Collider Timer":
				{
					flags[Flag.COLLIDING] = false;
					break;
				}
			case "Coyote Timer":
				{
					flags[Flag.IN_THE_AIR] = true;
					flags[Flag.IN_COYOTE_TIME] = false;

					//Event
					BodyEvents(BodyEvent.JUMP);
					break;
				}
			case "In the Air Timer":
				{
					flags[Flag.IN_THE_AIR] = true;
					break;
				}
			case "Climb Off Timer":
				{
					flags[Flag.CLIMBING] = false;
					rb.isKinematic = false;

					//Event
					BodyEvents?.Invoke(BodyEvent.JUMP);
					break;
				}
		}
	}

	/// <summary>
	/// This function lets the body know if it should move or if moving would cause trouble
	/// </summary>
	/// <param name="direction">Player's input</param>
	/// <returns></returns>
	bool CheckCollisionAngle(Vector3 direction)
	{
		//Set Variables
		Vector3 horizontalCollisionNormal = lastContact.normal;
		horizontalCollisionNormal.y = 0;

		_collisionAngles = new Vector2(Vector3.Angle(direction, horizontalCollisionNormal), Vector3.Angle(transform.up, lastContact.normal));

		//Conditions
		bool _conditionA = (_collisionAngles.y > _yMinAngle && _collisionAngles.y < _yMaxAngle);
		bool _conditionB = (_collisionAngles.x > _xMinAngle && _collisionAngles.x < _xMaxAngle);

		//Decide return
		if (!flags[Flag.COLLIDING]) return true;
		return !(_conditionA && _conditionB);
	}

	/// <summary>
	/// Makes the player jump
	/// </summary>
	void ControlJump()
	{
		if (flags[Flag.JUMP_REQUEST])
		{
			flags[Flag.JUMP_REQUEST] = false;
			//Physics
			Vector3 newVel = rb.velocity;
			newVel.y = 0;
			rb.velocity = newVel;
			rb.AddForce(Vector3.up * PlayerProperties.Instance.JumpForce, ForceMode.Impulse);
			//Event
			BodyEvents?.Invoke(BodyEvent.JUMP);
			//_jumpTimer.Play();

			//Sound
			PlaySound(0);
		}
	}

	/// <summary>
	/// Accelerates the velocity of the player while falling to eliminate feather falling effet
	/// </summary>
	void AccelerateFall()
	{
		if (rb.velocity.y < .5 && rb.velocity.y > -15)
		{
			rb.velocity += Vector3.up * Physics2D.gravity.y * (PlayerProperties.Instance.FallMultiplier - 1) * Time.deltaTime;
		}
	}

	void ControlClimb()
	{
		if (flags[Flag.CLIMB_REQUEST] && flags[Flag.TOUCHING_CLIMBABLE])
		{
			_climbTimer.Stop();
			if (flags[Flag.CLIMBING]) return;
			flags[Flag.CLIMBING] = true;
			rb.isKinematic = true;

			//Event
			BodyEvents?.Invoke(BodyEvent.CLIMB);
		}
		else if (flags[Flag.CLIMBING])
		{
			if (!_climbTimer.Counting)
			{
				_climbTimer.Play();
			}
		}
	}

	/// <summary>
	/// Turn on and off the gliding
	/// </summary>
	/// <param name="HoldingButton"></param>
	public void TurnGlide(bool HoldingButton)
	{
		if (HoldingButton && rb.velocity.y < 0 /*&& flags[Flag.IN_THE_AIR]*/)
		{
			if (!flags[Flag.GLIDING])
			{
				rb.drag = PlayerProperties.Instance.GlidingDrag;
				flags[Flag.GLIDING] = true;
			}
		}
		else
		{
			rb.drag = 0;
			flags[Flag.GLIDING] = false;
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
	/// </summary>
	/// <param name="input"></param>
	public void MoveHorizontally(Vector3 direction, float speed)
	{
		if (CheckCollisionAngle(direction))
		{
			rb.velocity = direction * speed + rb.velocity.y * Vector3.up;
		}
	}

	public void Climb(Vector2 Input)
	{
		if (!flags[Flag.CLIMBING]) return;
		if (lastClimbable) transform.forward = lastClimbable.forward;
		if (flags[Flag.TOUCHING_CLIMBABLE_TOP_SOLID] && Input.y > 0) Input.y = 0;
		transform.position += (transform.right * Input.x + transform.up * Input.y) * PlayerProperties.Instance.ClimbSpeed * Time.deltaTime;
	}

	/// <summary>
	/// Stops Characters jump to give the user more control
	/// </summary>
	public void StopJump()
	{
		rb.velocity += Vector3.up * Physics2D.gravity.y * (PlayerProperties.Instance.LowJumpMultiplier - 1) * Time.deltaTime;
	}

	public void PushPlayer()
	{
		rb.isKinematic = false;
		rb.AddForce(Vector3.up * PlayerProperties.Instance.JumpForce + transform.forward, ForceMode.Impulse);
	}
	public void Push(Vector3 direction, float force)
	{
		TurnGlide(false);
		rb.AddForce(direction.normalized * force, ForceMode.Impulse);
	}
	public Collider GetLandCollider()
	{
		return landCollider;
	}
	#endregion

	#region Collisions
	private void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.layer == climbableTopLayer.Layer)
		{
			BodyEvents(BodyEvent.TRIGGER);
		}
		else
		{
			flags[Flag.IN_THE_AIR] = false;
			BodyEvents?.Invoke(BodyEvent.LAND);
		}
	}
	private void OnTriggerExit(Collider other)
	{
		flags[Flag.IN_THE_AIR] = true;
		BodyEvents?.Invoke(BodyEvent.JUMP);
	}

	private void OnCollisionStay(Collision collision)
	{
		flags[Flag.COLLIDING] = true;
		lastContact = collision.contacts[0];
	}
	#endregion
}