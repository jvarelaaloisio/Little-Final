using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;

[RequireComponent(typeof(Player_Body_OLD))]
[RequireComponent(typeof(DamageHandler))]
[RequireComponent(typeof(Animator))]
public class Player_Brain_OLD : GenericFunctions, IUpdateable
{
	#region Variables

	#region Public
	public bool GodMode;
	#endregion

	#region Serialized
	Vector3 origin;
	[SerializeField]
	[UnityEngine.Range(0, 5)]
	float cameraFollowTime = 0.5f;
	[SerializeField]
	float throwForce = 8;
	#endregion

	#region Private

	GameManager gameManager;
	UpdateManager updateManager;
	Player_Animator myAnimator;
	Player_Body_OLD myBody;
	DamageHandler myDamageHandler;
	IPickable _itemPicked;

	PlayerProperties properties;

	Timer _followCameraTimer;
	IPlayerInput input;
	Vector2 walkInput;
	Vector3 targetDirection;

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
			updateManager = GameObject.FindObjectOfType<UpdateManager>();
			updateManager.AddItem(this);
		}
		catch (NullReferenceException)
		{
			print(this.name + "update manager not found");
		}
		try
		{
			gameManager = GameObject.FindObjectOfType<GameManager>();
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
		myAnimator.ChangeState(state);
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
		return myBody.Position;
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
		myBody = GetComponent<Player_Body_OLD>();
		myDamageHandler = GetComponent<DamageHandler>();
		myAnimator = GetComponent<Player_Animator>();
		//input = gameObject.AddComponent<DesktopInput>();
		properties = gameManager.PlayerProperties;
	}
	/// <summary>
	/// Setups the event handlers for the body events
	/// </summary>
	void SetupHandlers()
	{
		myBody.BodyEvents += BodyEventHandler;
		myDamageHandler.LifeChangedEvent += LifeChangedHandler;
		myAnimator.AnimationEvents += AnimationEventHandler;
	}
	#endregion

	#region Input

	/// <summary>
	/// Tells the body to change the velocity in the horizontal plane
	/// </summary>
	void ControlHorMovement()
	{
		walkInput = input.ReadHorInput();
		UpdateTargetDirection();

		myBody.MoveHorizontally(walkInput);
		UpdateForward();
	}

	/// <summary>
	/// reads input to tell the body if the player wants to climb
	/// </summary>
	void ReadClimbInput()
	{
		myBody.InputClimb = input.ReadClimbInput();
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
		if (walkInput != Vector2.zero) FollowCameraRotation();

		//Jump
		if (input.ReadJumpInput()) myBody.InputJump = true;
		ReadClimbInput();
	}

	/// <summary>
	/// Reads the input for the Jumping State
	/// </summary>
	void ReadJumpingStateInput()
	{
		ControlHorMovement();

		if (walkInput != Vector2.zero) FollowCameraRotation();
		bool jumpInput = input.ReadJumpInput();
		myBody.InputGlide = jumpInput;
		if (!jumpInput && myBody.Velocity.y > 0) myBody.StopJump();

		ReadClimbInput();
	}

	void ReadClimbingStateInput()
	{
		walkInput = input.ReadHorInput();
		myBody.Climb(walkInput);
	}

	void UpdateTargetDirection()
	{
		//direction
		var forward = Camera.main.transform.TransformDirection(Vector3.forward);
		forward.y = 0;

		var right = Camera.main.transform.TransformDirection(Vector3.right);

		targetDirection = walkInput.x * right + walkInput.y * forward;
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
					myBody.PushPlayer();
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
				if (myBody.PlayerInTheAir) state = PlayerState.JUMPING;
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
		gameManager.PlayerIsDead(false);
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
		if (walkInput != Vector2.zero && targetDirection.magnitude > .1f)
		{
			targetDirection.Normalize();
			float differenceRotation = Vector3.Angle(transform.forward, targetDirection);

			float dot = Vector3.Dot(transform.right, targetDirection);
			var leastTravelDirection = dot < 0 ? -1 : 1;
			transform.Rotate(transform.up, differenceRotation * leastTravelDirection * properties.TurnSpeed * Time.deltaTime);
		}
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