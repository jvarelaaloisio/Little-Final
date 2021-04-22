using System.Collections;
using System.Collections.Generic;
using System;
public class dumbCommand
{
	#region Variables

	#region Public
	public delegate void FunctionModel();
	public Action<object[]> Method => method;
	public bool state
	{
		set
		{
			_state = value;
		}
		get
		{
			return _state;
		}
	}
	public string name
	{
		get
		{
			return _name;
		}
	}
	public string description
	{
		get
		{
			return _description;
		}
	}
	#endregion

	#region Private
	Action<object[]> method;
	string _name, _description;
	bool _state;
	#endregion

	#endregion

	#region Public
	public dumbCommand(string NewName, string NewDescription, Action<object[]> method)
	{
		_name = NewName;
		_description = NewDescription;
		this.method = method;
	}

	#endregion
}
