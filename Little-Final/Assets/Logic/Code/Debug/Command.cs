using System.Collections;
using System.Collections.Generic;
public class Command
{
	#region Variables

	#region Public
	public delegate void FunctionModel();
	public FunctionModel function
	{
		get
		{
			return _function;
		}
	}
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
	FunctionModel _function;
	string _name, _description;
	bool _state;
	#endregion

	#endregion

	#region Public
	public Command(string NewName, string NewDescription, FunctionModel NewFunction)
	{
		_name = NewName;
		_description = NewDescription;
		_function = NewFunction;

	}

	#endregion
}
