using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UpdateManagement;
public class GameManager : MonoBehaviour, IUpdateable
{
	#region Variables

	#region Serialized
	[SerializeField]
	Transform player;
	[SerializeField]
	PP_Walk playerProperties;
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
	public PP_Walk PlayerProperties
	{
		get
		{
			return PlayerProperties;
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
	bool _pause;
	bool _playerIsAlive = true;
	#endregion

	#endregion

	#region Unity
	private void Start()
	{
		UpdateManager.Instance.Subscribe(this);
		if (!player) player = GameObject.FindObjectOfType<Player_Brain_DEPRECATED>().GetComponent<Transform>();
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
