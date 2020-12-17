using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UpdateManagement;
public class GameManager : MonoBehaviour
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

	private void Update()
	{
#if UNITY_EDITOR
		if (Input.GetButtonDown("Console"))
		{
			if (DebugConsole.IsOpened)
			{
				UpdateManager.SetPause(false);
				DebugConsole.Close();
			}
			else
			{
				UpdateManager.SetPause(true);
				DebugConsole.Open();
			}
		}
		ControlTimeScale();
#endif
	}

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
	#endregion
}
