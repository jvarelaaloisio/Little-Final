using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;

[RequireComponent(typeof(Player_Body))]
[RequireComponent(typeof(Damage_Handler))]
public class Player_Brain : GenericFunctions, IUpdateable
{
	#region Variables

	#region Public
	public bool GodMode;
	#endregion

	#region Serialized
	Vector3 origin;
	[SerializeField]
	[Range(0, 5)]
	float cameraFollowTime = 0.5f;
	[SerializeField]
	float throwForce = 8;
	#endregion

	#region Private

	#region Other Objects
	GameManager _manager;
	UpdateManager _uManager;
	Player_Animator _animControl;
	Player_Body _body;
	Damage_Handler _damageHandler;
	IPickable _itemPicked;
	#endregion

	Timer _followCameraTimer;
	IPlayerInput input;
	Vector2 _movInput;

	#region Flags
	enum Flag
	{
	}
	Dictionary<Flag, bool> _flags = new Dictionary<Flag, bool>();
	#endregion

	#region States
	[SerializeField]
	PlayerState state;
	#endregion

	#endregion

	#endregion

	#region Unity
	void Start()
	{
		origin = transform.position;
		origin.y += 2;
		try
		{
			_uManager = GameObject.FindObjectOfType<UpdateManager>();
			_uManager.AddItem(this);
		}
		catch (NullReferenceException)
		{
			print(this.name + "update manager not found");
		}
		try
		{
			_manager = GameObject.FindObjectOfType<GameManager>();
		}
		catch (NullReferenceException)
		{
			print(this.name + "game manager not found");
		}
		InitializeVariables();
		SetupHandlers();
		SetupFlags();
	}
	public void OnUpdate()
	{
		_animControl.ChangeState(state);
		switch (state)
		{
			case PlayerState.WALKING:
				{
					ReadWalkingStateInput();
					ReadPickInput();
					break;
				}
			case PlayerState.JUMPING:
				{
					ReadJumpingStateInput();
					ReadPickInput();
					break;
				}
			case PlayerState.CLIMBING:
				{
					ReadClimbingStateInput();
					ReadClimbInput();
					break;
				}
			case PlayerState.CLIMBING_TO_TOP:
				{

					break;
				}
			case PlayerState.GOT_HIT:
				{
					break;
				}
			case PlayerState.DEAD:
				{
					//SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
					transform.position = origin;
					break;
				}
		}
	}
	#endregion

	#region Public
	public Vector3 GivePostion()
	{
		return _body.Position;
	}
	#endregion

	#region Private

	#region Setup
	/// <summary>
	/// Setups the flags
	/// </summary>
	void SetupFlags()
	{
		foreach (var flag in (Flag[])Enum.GetValues(typeof(Flag)))
		{
			_flags.Add(flag, false);
		}
	}

	/// <summary>
	/// Called in the start to prepeare this script
	/// </summary>
	void InitializeVariables()
	{
		_body = GetComponent<Player_Body>();
		_damageHandler = GetComponent<Damage_Handler>();
		try
		{
			_animControl = GetComponentInChildren<Player_Animator>();
		}
		catch (NullReferenceException)
		{
			print(this.name + "anim script not found");
		}
		input = gameObject.AddComponent<DesktopInput>();
		_followCameraTimer = SetupTimer(cameraFollowTime, "Follow Camera Timer");
	}
	/// <summary>
	/// Setups the event handlers for the body events
	/// </summary>
	void SetupHandlers()
	{
		_body.BodyEvents += BodyEventHandler;
		_damageHandler.LifeChangedEvent += LifeChangedHandler;
		_animControl.AnimationEvents += AnimationEventHandler;
	}
	#endregion

	#region Input

	/// <summary>
	/// Tells the body to change the velocity in the horizontal plane
	/// </summary>
	void ControlHorMovement()
	{
		_movInput = input.ReadHorInput();
		_body.Walk(_movInput);
		//UpdateForward();
	}

	/// <summary>
	/// reads input to tell the body if the player wants to climb
	/// </summary>
	void ReadClimbInput()
	{
		_body.InputClimb = input.ReadClimbInput();
	}

	void ReadPickInput()
	{
		if (input.ReadPickInput())
		{
			if (_itemPicked == null)
			{
				_itemPicked = GetComponentInChildren<Player_FrontCollider>().PickableItem;
				if (_itemPicked != null)
				{
					_itemPicked.Pick(transform);
				}
			}
			else
			{
				_itemPicked.Release();
				_itemPicked = null;
			}
		}
		if (input.ReadThrowInput() && _itemPicked != null)
		{
			_itemPicked.Throw(throwForce, transform.forward);
			_itemPicked = null;
		}
	}

	/// <summary>
	/// Reads the input for the walking state
	/// </summary>
	void ReadWalkingStateInput()
	{
		ControlHorMovement();
		//REVISAR
		if (_movInput != Vector2.zero) FollowCameraRotation();

		//Jump
		if (input.ReadJumpInput()) _body.InputJump = true;
		ReadClimbInput();
	}

	/// <summary>
	/// Reads the input for the Jumping State
	/// </summary>
	void ReadJumpingStateInput()
	{
		ControlHorMovement();

		if (_movInput != Vector2.zero) FollowCameraRotation();
		bool jumpInput = input.ReadJumpInput();
		_body.InputGlide = jumpInput;
		if (!jumpInput && _body.Velocity.y > 0) _body.StopJump();

		ReadClimbInput();
	}

	void ReadClimbingStateInput()
	{
		_movInput = input.ReadHorInput();
		_body.Climb(_movInput);
	}

	#endregion

	#region EventHandlers
	/// <summary>
	/// Handles events from the body
	/// </summary>
	/// <param name="typeOfEvent"></param>
	void BodyEventHandler(BodyEvent typeOfEvent)
	{
		print(typeOfEvent);
		switch (typeOfEvent)
		{
			case BodyEvent.LAND:
				{
					state = PlayerState.WALKING;
					break;
				}
			case BodyEvent.JUMP:
				{
					state = PlayerState.JUMPING;
					break;
				}
			case BodyEvent.CLIMB:
				{
					state = PlayerState.CLIMBING;
					break;
				}
			case BodyEvent.TRIGGER:
				{
					if (state == PlayerState.CLIMBING)
					{
						_body.PushPlayer();
						state = PlayerState.CLIMBING_TO_TOP;
					}
					break;
				}
		}
	}

	/// <summary>
	/// Handles events from the damage_handler
	/// </summary>
	/// <param name="newLife"></param>
	void LifeChangedHandler(float newLife)
	{
		if (newLife <= 0) Die();
		else
		{
			state = PlayerState.GOT_HIT;
		}
	}

	/// <summary>
	/// Handles events from the timers
	/// </summary>
	/// <param name="ID"></param>
	protected override void TimerFinishedHandler(string ID)
	{
	}

	/// <summary>
	/// Handles events from the animation script
	/// </summary>
	/// <param name="typeOfEvent"></param>
	void AnimationEventHandler(AnimationEvent typeOfEvent)
	{
		switch (typeOfEvent)
		{
			case AnimationEvent.HIT_FINISHED:
				{
					if (_body.IsInTheAir) state = PlayerState.JUMPING;
					else state = PlayerState.WALKING;
					break;
				}
			case AnimationEvent.CLIMB_FINISHED:
				{
					state = PlayerState.CLIMBING_TO_TOP;
					break;
				}
		}
	}
	#endregion

	/// <summary>
	/// Here goes everything to do when the player dies
	/// </summary>
	void Die()
	{
		if (GodMode || state == PlayerState.DEAD) return;
		_manager.PlayerIsDead(false);
	}

	/// <summary>
	/// Makes the body rotate to the camera direction
	/// </summary>
	void FollowCameraRotation()
	{
		if (_followCameraTimer.Counting) return;
		_followCameraTimer.Play();
	}

	void UpdateForward()
	{
		float pivot = SmoothFormula(_followCameraTimer.CurrentTime, cameraFollowTime);
		if (_followCameraTimer.Counting) transform.eulerAngles = new Vector3(0, Mathf.LerpAngle(transform.eulerAngles.y, _manager.GiveCamera().eulerAngles.y, pivot), 0);
	}
	#endregion

	#region Gizmos
	private void OnDrawGizmos()
	{
		Gizmos.color = Color.red;
		Gizmos.DrawLine(transform.position, transform.position + transform.forward);
	}

	#endregion

	//	HardCode
	private void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.layer == 17)
		{
			origin = transform.position + Vector3.up;
		}
	}
}