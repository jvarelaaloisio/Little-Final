using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class CameraBehaviour : GenericFunctions, IUpdateable
{
	#region Variables

	#region Constants
	const string _mouseXaxis = "Mouse X", _mouseYaxis = "Mouse Y", _joyXaxis = "RsXaxis", _joyYaxis = "RsYaxis";
	#endregion

	#region Serialized
	[SerializeField]
	Vector3 positionOffset;
	[SerializeField]
	float YaxisMinAngle = -35, YaxisMaxAngle = 45;
	[SerializeField]
	[Range(0f, 20f)]
	float sensitivityX = 2.5f,
		sensitivityY = 5f,
		joySensitivityRatio = 5,
		rotationTime;
	[SerializeField]
	bool yAxisInverted, xAxisInverted;
	[Header("Debug")]
	[SerializeField]
	Transform cameraTransform;
	#endregion

	#region Private
	GameManager _manager;
	UpdateManager _uManager;
	Timer _rotationTimer;
	Vector2 _mouseInput, _joyInput;
	Vector3 _playerPos;
	float _xAngle, _yAngle;
	float YAngleController
	{
		get
		{
			return _yAngle;
		}
		set
		{
			if (value > 1) _yAngle = 1;
			else if (value < 0) _yAngle = 0;
			else _yAngle = value;
		}
	}
	float XAngleController
	{
		get
		{
			return _xAngle;
		}
		set
		{
			if (value > 360) _xAngle = 0;
			else if (value < 0) _xAngle = 360;
			else _xAngle = value;
		}
	}
	int YAxisInvertedMultiplier
	{
		get
		{
			if (yAxisInverted) return 1;
			else return -1;
		}
	}
	int XAxisInvertedMultiplier
	{
		get
		{
			if (xAxisInverted) return -1;
			else return 1;
		}
	}

	#region Flags
	enum State
	{
		FREE,
		FOLLOWING,
		FOLLOWING_SMOOTHLY
	}
	State _state;
	enum Flag
	{
		IS_CAMERA_INPUT,
		IS_FOLLOWING
	}
	Dictionary<Flag, bool> _flags = new Dictionary<Flag, bool>();
	enum Timers
	{
		ROTATION
	}
	Vector2 _initialPosCamera;
	#endregion
	#endregion

	#endregion

	#region Unity
	private void Start()
	{
		try
		{
			_uManager = GameObject.FindObjectOfType<UpdateManager>();
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
		if (_uManager != null) _uManager.AddItem(this);
		XAngleController = _manager.GetPlayerRotation().y;
		YAngleController = .5f;
		InitializeFlags();
		InitializeTimers();
		UpdateRotation(new Vector2(0.1f, 0));
	}
	public void OnUpdate()
	{
		FollowPlayer();
		ReadInput();
		//cameraTransform.position = GetDistanceFromPlayer(cameraTransform.position, 3);
		_state = GetNewState(_state);
		switch (_state)
		{
			case State.FREE:
			{
				break;
			}
			case State.FOLLOWING:
			{
				Rotate();
				break;
			}
			case State.FOLLOWING_SMOOTHLY:
			{
				RotateSmoothly();
				break;
			}
		}
	}
	#endregion

	#region Private
	/// <summary>
	/// Setup for the flags
	/// </summary>
	void InitializeFlags()
	{
		foreach (var flag in (Flag[])Enum.GetValues(typeof(Flag)))
		{
			_flags.Add(flag, false);
		}
	}
	/// <summary>
	/// Setup for the timers
	/// </summary>
	void InitializeTimers()
	{
		_rotationTimer = SetupTimer(rotationTime, "Rotation Timer");
	}
	protected override void TimerFinishedHandler(string ID)
	{
	}

	/// <summary>
	/// Returns a new state depending on flags
	/// </summary>
	/// <param name="actualState"></param>
	/// <returns></returns>
	State GetNewState(State actualState)
	{
		switch (actualState)
		{
			case State.FREE:
			{
				if (_flags[Flag.IS_CAMERA_INPUT])
				{
					_rotationTimer.Play();
					//_rotationTimer.GottaCount = true;
					_initialPosCamera.x = transform.eulerAngles.x;
					_initialPosCamera.y = transform.eulerAngles.y;
					return State.FOLLOWING_SMOOTHLY;
				}
				break;
			}
			case State.FOLLOWING:
			{
				if (!_flags[Flag.IS_CAMERA_INPUT]) return State.FREE;
				break;
			}
			case State.FOLLOWING_SMOOTHLY:
			{
				if (!_rotationTimer.Counting)
				{
					if (_flags[Flag.IS_CAMERA_INPUT]) return State.FOLLOWING;
					else return State.FREE;
				}
				break;
			}
		}
		return actualState;
	}

	/// <summary>
	/// Rotates this GO using the given Value
	/// </summary>
	/// <param name="Values">Vector 2 that controls the X and Y axis</param>
	void UpdateRotation(Vector2 Values)
	{
		if (!_flags[Flag.IS_CAMERA_INPUT]) return;
		//Y axis rotation setup
		YAngleController += Values.y * sensitivityY / 360 * YAxisInvertedMultiplier;

		//Rotate X Axis setup
		XAngleController += Values.x * sensitivityX * XAxisInvertedMultiplier;
	}

	void Rotate()
	{
		//if (_rotationTimer.CurrentTime >= rotationTime - 0.1f && _flags[Flag.IS_CAMERA_INPUT]) _rotationTimer.GottaCount = true;
		float xRotObjective = Mathf.LerpAngle(YaxisMinAngle, YaxisMaxAngle, YAngleController);
		float xRot = xRotObjective;
		//float yRot = Mathf.LerpAngle(transform.eulerAngles.y, XAngleController, SmoothFormula(_rotationTimer.CurrentTime, rotationTime));
		float yRot = XAngleController;
		transform.eulerAngles = new Vector3(xRot, yRot, transform.rotation.z);
	}
	void RotateSmoothly()
	{
		//if (_rotationTimer.CurrentTime >= rotationTime - 0.1f && _flags[Flag.IS_CAMERA_INPUT]) _rotationTimer.GottaCount = true;
		float xRotObjective = Mathf.LerpAngle(YaxisMinAngle, YaxisMaxAngle, YAngleController);
		//float xRot = Mathf.LerpAngle(transform.eulerAngles.x, xRotObjective, _rotationTimer.CurrentTime / rotationTime);
		//float yRot = Mathf.LerpAngle(transform.eulerAngles.y, XAngleController, _rotationTimer.CurrentTime / rotationTime);
		float pivot = SmoothFormula(_rotationTimer.CurrentTime, rotationTime);
		float xRot = Mathf.LerpAngle(_initialPosCamera.x, xRotObjective, pivot);
		float yRot = Mathf.LerpAngle(_initialPosCamera.y, XAngleController, pivot);
		//print("xRotObj: " + xRotObjective + "; xRot: " + xRot + "; yRot: " + yRot);
		transform.eulerAngles = new Vector3(xRot, yRot, transform.rotation.z);
	}

	Vector3 GetDistanceFromPlayer(Vector3 originalPosition, float sphereRadius)
	{
		float x = cameraTransform.position.y - transform.position.y;
		Vector3 result = originalPosition;
		if (x < 0)
		{
			result.y = Mathf.Sqrt(Mathf.Pow(sphereRadius, 2) + Mathf.Pow(x, 2));
		}
		else
		{
			result.y = Mathf.Sqrt(Mathf.Pow(sphereRadius, 2) * (Mathf.Pow(sphereRadius, 2) + Mathf.Pow(x, 2)));
		}
		return result;
	}

	/// <summary>
	/// Reads the input for the camera from the mouse and the Joystick and calls the rotate statement
	/// </summary>
	void ReadInput()
	{
		_mouseInput = new Vector2(Input.GetAxis(_mouseXaxis), Input.GetAxis(_mouseYaxis));
		_joyInput = new Vector2(Input.GetAxis(_joyXaxis), -Input.GetAxis(_joyYaxis)) * joySensitivityRatio;
		_flags[Flag.IS_CAMERA_INPUT] = (_mouseInput != Vector2.zero || _joyInput != Vector2.zero);
		if (_mouseInput != Vector2.zero) UpdateRotation(_mouseInput);
		if (_joyInput != Vector2.zero) UpdateRotation(_joyInput);
	}

	/// <summary>
	/// Gets player's position through the Manager and snaps to it
	/// </summary>
	void FollowPlayer()
	{
		_playerPos = _manager.GetPlayerPosition();
		if (_playerPos != transform.position + positionOffset)
		{
			transform.position = _playerPos + positionOffset;
		}
	}
	#endregion

	#region Gizmos
	private void OnDrawGizmos()
	{
		Gizmos.color = Color.yellow;
		Gizmos.DrawSphere(cameraTransform.position, .5f);
		Gizmos.DrawSphere(transform.position, .3f);
	}
	#endregion
}
