using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.UI;

public class MobileInput : MonoBehaviour, IPlayerInput, IUpdateable
{
	#region Variables

	#region Public

	#endregion

	#region Private
	UpdateManager _uManager;
	UnityEngine.UI.Button[] buttonGOs;
	enum ButtonType
	{
		WALK,
		JUMP,
		CLIMB,
		CAM
	}
	Dictionary<ButtonType, UnityEngine.UI.Button> buttons = new Dictionary<ButtonType, UnityEngine.UI.Button>();
	#endregion

	#endregion

	#region Unity
	void Start()
	{
		
		SetupButtons();
	}

	public void OnUpdate()
	{

	}
	#endregion

	#region Private
	void SetupButtons()
	{
		buttonGOs = GameObject.FindObjectsOfType<UnityEngine.UI.Button>();
		foreach (var button in buttonGOs)
		{
			foreach (var type in (ButtonType[])Enum.GetValues(typeof(ButtonType)))
			{
				if(button.name.ToLower() == Enum.GetName(typeof(ButtonType), type))
				{
					buttons.Add(type, button);
				}
			}
		}
	}
	#endregion

	#region Public
	public Vector2 ReadHorInput()
	{
		throw new System.NotImplementedException();
	}
	public bool ReadClimbInput()
	{
		throw new System.NotImplementedException();
	}

	public bool ReadJumpInput()
	{
		throw new System.NotImplementedException();
	}

	public bool ReadPickInput()
	{
		throw new NotImplementedException();
	}

	public bool ReadThrowInput()
	{
		throw new NotImplementedException();
	}


	#endregion
}
