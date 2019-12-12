using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class GameManager : MonoBehaviour, IUpdateable
{
	#region Variables

	#region Serialized
	[SerializeField]
	CameraBehaviour cameraPivot;
	[SerializeField]
	Transform player;
	[SerializeField]
	[Range(0, 1f)]
	float timeScale = 1;
	#endregion

	#region Getters
	public bool IsPlayerAlive
	{
		get
		{
			return _playerIsAlive;
		}
	}
	#endregion

	#region Setters
	public bool Pause
	{
		set
		{
			if (!value) timeScale = 1;
			_pause = value;
		}
		get
		{
			return _pause;
		}
	}
	#endregion

	#region Private
	UpdateManager _uManager;
	bool _pause;
	bool _playerIsAlive = true;
	#endregion

	#endregion

	#region Unity
	private void Start()
	{
		try
		{
			_uManager = GameObject.FindObjectOfType<UpdateManager>();
			_uManager.AddItem(this);
		}
		catch (NullReferenceException)
		{
			print(this.name + "update manager not found");
		}
		if (!player) player = GameObject.FindObjectOfType<Player_Brain>().GetComponent<Transform>();
		Cursor.visible = false;
	}
	public void OnUpdate()
	{
		ControlTimeScale();
		controlPause();
	}
	#endregion

	#region Public
	/// <summary>
	/// Returns player's position
	/// </summary>
	/// <returns></returns>
	public Vector3 GetPlayerPosition()
	{
		return player.position;
	}

	/// <summary>
	/// Returns player's rotation
	/// </summary>
	/// <returns></returns>
	public Vector3 GetPlayerRotation()
	{
		return player.eulerAngles;
	}
	public void PlayerIsDead(bool Win)
	{
		_playerIsAlive = false;
	}

	/// <summary>
	/// Returns the camera transform
	/// </summary>
	/// <returns></returns>
	public Transform GiveCamera()
	{
		return cameraPivot.transform;
	}
	#endregion

	#region Private
	void ControlTimeScale()
	{
		Time.timeScale = timeScale;
	}

	void controlPause()
	{
		timeScale = _pause ? 0 : timeScale;
	}
	#endregion
}
