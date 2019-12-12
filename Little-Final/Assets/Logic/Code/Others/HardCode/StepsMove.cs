using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class StepsMove : GenericFunctions, IUpdateable
{
	Player_Rewards pRewards;
	UpdateManager _uManager;
	public int moonIndex;
	public float timeToMove;
	Timer _moveTimer;
	Vector3 _origin,
		_obj;
	void Start()
	{
		pRewards = GameObject.FindObjectOfType<Player_Rewards>();
		if (!pRewards) return;
		try
		{
			_uManager = GameObject.FindObjectOfType<UpdateManager>();
			_uManager.AddItem(this);
		}
		catch (NullReferenceException)
		{
			print(this.name + "update manager not found");
		}
		_moveTimer = SetupTimer(timeToMove, "");
	}
	public void OnUpdate()
	{
		if (_moveTimer.Counting)
		{
			transform.position = Vector3.Lerp(_origin, _obj, _moveTimer.CurrentTime / timeToMove);
		}
		else
		{
			if (pRewards.Moons == moonIndex)
			{
				_origin = transform.position;
				_obj = transform.position + transform.right * 3;
				//_obj.x += 3;
				_moveTimer.Play();
			}
		}
	}

	protected override void TimerFinishedHandler(string ID)
	{
		_uManager.RemoveItem(this);
	}
}
