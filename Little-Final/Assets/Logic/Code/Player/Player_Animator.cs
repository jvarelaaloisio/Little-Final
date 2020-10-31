using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public delegate void AnimationEvents(AnimationEvent typeOfEvent);

public class Player_Animator : MonoBehaviour, IUpdateable_DEPRECATED
{
	#region Variables

	#region Constant
	const string CROUCH_FLAG = "Crouch",
	SPEED_X = "SpeedX",
	SPEED_Y = "SpeedY",
	SPEED_Z = "SpeedZ",
	ANIMATION_STATE = "State";
	#endregion

	#region Public
	public event AnimationEvents AnimationEvents;
	#endregion

	#region Private
	UpdateManager_DEPRECATED _uManager;
	Player_Body_DEPRECATED _body;
	Animator _anim;
	PlayerState_DEPRECATED _state;
	PlayerState_DEPRECATED State
	{
		set
		{
			if (_state != value) _anim.SetFloat(ANIMATION_STATE, (int)value);
			_state = value;
		}
	}
	#endregion

	#endregion

	#region Unity
	void Start()
	{
		try
		{
			_uManager = GameObject.FindObjectOfType<UpdateManager_DEPRECATED>();
			_uManager.AddItem(this);
		}
		catch (NullReferenceException)
		{
			print(this.name + "update manager not found");
		}
		try
		{
			_anim = GetComponent<Animator>();
		}
		catch (NullReferenceException)
		{
			print(this.name + "animator not found");
		}
		try
		{
			_body = GetComponentInParent<Player_Body_DEPRECATED>();
		}
		catch (NullReferenceException)
		{
			print(this.name + "body not found");
		}
	}
	public void OnUpdate()
	{
		SetSpeedParameter(_body.Velocity);
	}
	#endregion

	#region Public

	#region Events
	public void HitFinished()
	{
		AnimationEvents?.Invoke(AnimationEvent.HIT_FINISHED);
	}
	public void ClimbFinished()
	{
		AnimationEvents?.Invoke(AnimationEvent.CLIMB_FINISHED);
	}
	#endregion

	public void SetCrouch(bool Value)
	{
		_anim.SetBool(CROUCH_FLAG, Value);
	}

	public void SetSpeedParameter(Vector3 Speed)
	{
		_anim.SetFloat(SPEED_X, Speed.x);
		_anim.SetFloat(SPEED_Y, Speed.y);
		_anim.SetFloat(SPEED_Z, Speed.z);
	}

	public void ChangeState(PlayerState_DEPRECATED newState)
	{
		State = newState;
	}
	#endregion
}
