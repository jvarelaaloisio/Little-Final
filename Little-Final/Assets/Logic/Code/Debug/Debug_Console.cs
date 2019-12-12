using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System;

public class Debug_Console : MonoBehaviour, IUpdateable
{
	#region Variables

	#region Serialized
	[SerializeField]
	Text consoleBody;
	[SerializeField]
	InputField inputText;

	#region Specific to commands
	[SerializeField]
	GameObject Container;
	[SerializeField]
	float FlashMultiplier = 3;
	#endregion

	#endregion

	#region Private
	UpdateManager _uManager;
	GameManager _gManager;
	GameObject _player;
	Player_Body _playerBody;
	Player_Brain _playerBrain;
	List<Command> _commands = new List<Command>();
	enum Cmd
	{
		help,
		godMode,
		life,
		flash
	}

	Vector3 _savedPosition;
	bool _opened;
	#endregion

	#endregion

	#region Unity
	void Start()
	{
		try
		{
			_playerBrain = GameObject.FindObjectOfType<Player_Brain>();
			_playerBody = GameObject.FindObjectOfType<Player_Body>();
		}
		catch (NullReferenceException)
		{
			print(this.name + ": player not setup");
		}
		try
		{
			_gManager = GameObject.FindObjectOfType<GameManager>();
		}
		catch (NullReferenceException)
		{
			print(this.name + ": game manager not found");
		}
		try
		{
			_uManager = GameObject.FindObjectOfType<UpdateManager>();
		}
		catch (NullReferenceException)
		{
			print(this.name + ": update manager not found");
		}
		if (_uManager != null) _uManager.AddItem(this);
		_commands.Add(new Command("help", "Muestra la descripción de todos los comandos", Help));
		_commands.Add(new Command("godmode", "Sos inmortal", GodMode));
		_commands.Add(new Command("savePosition", "guarda la posición actual", SavePosition));
		_commands.Add(new Command("loadPosition", "carga la posición guardada", LoadPosition));
		_commands.Add(new Command("flash", "te sentís re logi, eh (acelera al PJ)", Flash));
		_commands.Add(new Command("restart", "Reinicia el Nivel", loadLVL));
		_commands.Add(new Command("menu", "Vuelve al menú principal", loadMenu));
		_commands.Add(new Command("credits", "muestra los creditos", loadCredits));
	}

	public void OnUpdate()
	{
		ReadInput();
	}
	#endregion

	#region Private
	/// <summary>
	/// Adds new text to the Console Body
	/// </summary>
	/// <param name="NewFeedBack">Text to add</param>
	void WriteFeedBack(string NewFeedBack)
	{
		consoleBody.text += "\n" + NewFeedBack;
		inputText.ActivateInputField();
	}

	/// <summary>
	/// runs the mapped command
	/// </summary>
	void ExecuteCommand()
	{
		bool _commandRecognized = false;
		foreach (var x in _commands)
		{
			if (inputText.text == x.name)
			{
				x.function.Invoke();
				_commandRecognized = true;
				break;
			}
		}
		if (!_commandRecognized) WriteFeedBack("Comand: " + inputText.text + " not recognized");
		inputText.text = "";
	}

	#region Comands
	/// <summary>
	/// Shows all the command names and their description
	/// </summary>
	void Help()
	{
		foreach (Command x in _commands)
		{
			WriteFeedBack(x.name + ": " + x.description);
		}
	}

	public void GodMode()
	{
		_commands[(int)Cmd.godMode].state = !_commands[(int)Cmd.godMode].state;
		_playerBrain.GodMode = _commands[(int)Cmd.godMode].state;
		string _newState = _commands[(int)Cmd.godMode].state ? "on" : "off";
		WriteFeedBack("GodMode: " + _newState);
	}

	void SavePosition()
	{
		_savedPosition = _playerBody.Position;
		WriteFeedBack("Position saved to: " + _savedPosition);
	}

	void LoadPosition()
	{
		_playerBody.transform.position = _savedPosition;
		WriteFeedBack("Position loaded to: " + _savedPosition);
	}

	/// <summary>
	/// Multiplies the player's horizontal velocity
	/// </summary>
	/// <param name="multiplier">value to multiply player's horizontal velocity</param>
	public void Flash()
	{

		if (!_commands[(int)Cmd.flash].state)
		{
			_playerBody.flash = FlashMultiplier;
			WriteFeedBack("Flash: On");
		}
		else
		{
			_playerBody.flash = 1 / FlashMultiplier;
			WriteFeedBack("Flash: Off");
		}
		_commands[(int)Cmd.flash].state = !_commands[(int)Cmd.flash].state;
	}

	void loadLVL()
	{
		SceneManager.LoadScene(1);
	}
	void loadMenu()
	{
		SceneManager.LoadScene(0);
	}
	void loadCredits()
	{
		SceneManager.LoadScene(2);
	}
	#endregion

	/// <summary>
	/// Reads user input
	/// </summary>
	void ReadInput()
	{
		if (Input.GetButtonDown("Console"))
		{
			_opened = !_opened;
			Container.SetActive(_opened);
			_gManager.Pause = _opened;
			if (_opened)
			{
				inputText.ActivateInputField();
			}
		}
		if (_opened)
		{
			if (Input.GetKeyDown(KeyCode.Return))
			{
				ExecuteCommand();
			}
		}
	}
	#endregion
}
