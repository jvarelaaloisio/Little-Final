using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public delegate void BodyEvents_OLD(BodyEvent typeOfEvent);
[RequireComponent(typeof(Rigidbody))]
public class Player_Body_DEPRECATED : GenericFunctions, IUpdateable_DEPRECATED/*, IBody*/
{
	#region Variables

	public SO_Layer climbableTopLayer;
	
	#region Public
	public event BodyEvents BodyEvents;
	public Transform lastClimbable;
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

	UpdateManager_DEPRECATED updateManager;
	AudioManager audioManager;

	PP_Walk properties;
	Rigidbody rb;
	Timer_DEPRECATED _colTimer, _coyoteTimer, _jumpTimer, _climbTimer;

	ContactPoint lastContact;
	Vector3 _collisionAngles;
	float JumpingAccelerationFactor => flags[Flag.IN_THE_AIR] ? PP_Jump.Instance.JumpSpeed : 1;
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

	public bool IsInTheAir
	{
		get
		{
			return flags[Flag.IN_THE_AIR];
		}
	}
	#endregion

	#region Setters
	public bool PlayerInTheAir
	{
		get
		{
			return flags[Flag.IN_THE_AIR];
		}
		set
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
				Glide(false);
			}
			else if (!flags[Flag.IN_COYOTE_TIME] && !flags[Flag.IN_THE_AIR] && !flags[Flag.CLIMBING])
			{
				_coyoteTimer.Play();
				flags[Flag.IN_COYOTE_TIME] = true;
			}
		}
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
		audioManager = GameObject.Find("AudioManager").GetComponent<AudioManager>();
		try
		{
			updateManager = GameObject.FindObjectOfType<UpdateManager_DEPRECATED>();
			updateManager.AddFixedItem(this);
		}
		catch (NullReferenceException)
		{
			print(this.name + "update manager not found");
		}
		try
		{
			properties = GameObject.FindObjectOfType<GameManager>().PlayerProperties;
		}
		catch (NullReferenceException)
		{
			print(this.name + "no gameManager/playerProperties found");
		}
		rb = GetComponent<Rigidbody>();

		SetupFlags();
		InitializeTimers();
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
	/// Setups the timers
	/// </summary>
	void InitializeTimers()
	{
		_colTimer = SetupTimer(_colTimeToOff, "Collider Timer");
		_coyoteTimer = SetupTimer(PP_Jump.Instance.CoyoteTime, "Coyote Timer");
		_jumpTimer = SetupTimer(_inTheAirTimeToOff, "In the Air Timer");
		_climbTimer = SetupTimer(climbTimeToOff, "Climb Off Timer");
	}

	/// <summary>
	/// Event Handler for the timers
	/// </summary>
	protected override void TimerFinishedHandler(string ID)
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
	/// <param name="Input">Player's input</param>
	/// <returns></returns>
	bool DecideIfWalk(Vector2 Input)
	{
		//Set Variables
		Vector3 horizontalCollisionNormal = lastContact.normal;
		horizontalCollisionNormal.y = 0;
		Vector3 inputNormal = transform.forward * Input.y + transform.right * Input.x;

		_collisionAngles = new Vector2(Vector3.Angle(inputNormal, horizontalCollisionNormal), Vector3.Angle(transform.up, lastContact.normal));

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
			if (!flags[Flag.IN_THE_AIR])
			{
				//Physics
				Vector3 newVel = rb.velocity;
				newVel.y = 0;
				rb.velocity = newVel;
				rb.AddForce(Vector3.up * PP_Jump.Instance.JumpForce, ForceMode.Impulse);

				flags[Flag.IN_THE_AIR] = true;
				//Event
				BodyEvents?.Invoke(BodyEvent.JUMP);
				_jumpTimer.Play();

				//Sound
				PlaySound(0);
			}
		}
		else
		{
			Glide(flags[Flag.GLIDE_REQUEST]);
		}
	}

	/// <summary>
	/// Accelerates the velocity of the player while falling to eliminate feather falling effet
	/// </summary>
	void AccelerateFall()
	{
		if (rb.velocity.y < .5 && rb.velocity.y > -15)
		{
			rb.velocity += Vector3.up * Physics2D.gravity.y * (PP_Jump.Instance.FallMultiplier - 1) * Time.deltaTime;
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
	void Glide(bool HoldingButton)
	{
		if (HoldingButton && rb.velocity.y < 0 && flags[Flag.IN_THE_AIR])
		{
			if (!flags[Flag.GLIDING])
			{
				rb.drag = PP_Jump.Instance.GlidingDrag;
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
			audioManager.PlayCharacterSound(_soundEffects[Index]);

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
	public void MoveHorizontally(Vector2 input)
	{
		Vector3 NewVel;
		if (DecideIfWalk(input))
		{
			if (input.y == 0) NewVel = transform.right * input.x * Speed * JumpingAccelerationFactor;
			else
			{
				NewVel = transform.forward * input.y * Speed * JumpingAccelerationFactor;
				int rotationDirection = input.y > 0 ? 1 : -1;
				transform.Rotate(transform.up * input.x * properties.TurnSpeed * rotationDirection);
			}
			NewVel += Vector3.up * rb.velocity.y;
			rb.velocity = NewVel;
		}
	}

	public void Climb(Vector2 Input)
	{
		if (!flags[Flag.CLIMBING]) return;
		if (lastClimbable) transform.forward = lastClimbable.forward;
		if (flags[Flag.TOUCHING_CLIMBABLE_TOP_SOLID] && Input.y > 0) Input.y = 0;
		transform.position += (transform.right * Input.x + transform.up * Input.y) * PP_Climb.Instance.ClimbSpeed * Time.deltaTime;
	}

	/// <summary>
	/// Stops Characters jump to give the user more control
	/// </summary>
	public void StopJump()
	{
		rb.velocity += Vector3.up * Physics2D.gravity.y * (PP_Jump.Instance.LowJumpMultiplier - 1) * Time.deltaTime;
	}

	public void PushPlayer()
	{
		rb.isKinematic = false;
		rb.AddForce(Vector3.up * PP_Jump.Instance.JumpForce + transform.forward, ForceMode.Impulse);

	}
	public void Push(Vector3 direction, float force)
	{
		Glide(false);
		rb.AddForce(direction.normalized * force, ForceMode.Impulse);
	}
	#endregion

	#region Collisions
	private void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.layer == climbableTopLayer.Layer)
		{
			BodyEvents(BodyEvent.TRIGGER);
		}
	}

	private void OnCollisionStay(Collision collision)
	{
		flags[Flag.COLLIDING] = true;
		lastContact = collision.contacts[0];
	}

	private void OnCollisionExit(Collision collision)
	{
		if (flags[Flag.COLLIDING])
		{
			_colTimer.Play();
		}
	}

	#endregion
}