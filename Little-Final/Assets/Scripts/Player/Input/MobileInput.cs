using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.UI;

public class MobileInput : MonoBehaviour, IPlayerInput
{
	#region Variables

	#region Public

	#endregion

	#region Private
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
	public Vector2 GetHorInput()
	{
		throw new System.NotImplementedException();
	}
	public bool GetClimbInput()
	{
		throw new System.NotImplementedException();
	}

	public bool GetJumpInput()
	{
		throw new System.NotImplementedException();
	}
	[Obsolete]
	public bool GetLongJumpInput()
	{
		throw new NotImplementedException();
	}

	public bool GetPickInput()
	{
		throw new NotImplementedException();
	}

	public bool GetThrowInput()
	{
		throw new NotImplementedException();
	}

	public bool GetInteractInput()
	{
		throw new NotImplementedException();
	}

	public bool GetGlideInput()
	{
		throw new NotImplementedException();
	}

	public bool GetRunInput()
	{
		throw new NotImplementedException();
	}

	public bool GetSwirlInput()
	{
		throw new NotImplementedException();
	}



	#endregion
}
