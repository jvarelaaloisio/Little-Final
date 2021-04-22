using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.IO;
using System.Linq;
using Player;

public class DebugConsole : MonoBehaviour
{
	#region Variables
	public static bool IsOpened => Instance.isOpened;
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
	Dictionary<string, Vector3> savedPositions;
	private PlayerController player;
	private static DebugConsole instance;
	private static DebugConsole Instance
	{
		get
		{
			if (instance == null && FindObjectOfType<DebugConsole>() == null)
			{
				GameObject go = GameObject.Instantiate(Resources.Load<GameObject>("Prefabs/DebugConsoleCanvas"));
				instance = go.GetComponentInChildren<DebugConsole>();
			}
			return instance;
		}
	}
	List<dumbCommand> _commands = new List<dumbCommand>();
	enum Cmd
	{
		help,
		godMode,
		life,
		flash
	}
	private string lastCommand;
	bool isOpened;
	#endregion

	#endregion

	#region Unity
	void Start()
	{
		player = FindObjectOfType<PlayerController>();
		_commands.Add(new dumbCommand("help", "Muestra la descripción de todos los comandos", Help));
		_commands.Add(new dumbCommand("godmode", "Sos inmortal", GodMode));
		_commands.Add(new dumbCommand("savePosition", "guarda la posición actual", SavePosition));
		_commands.Add(new dumbCommand("loadPosition", "carga la posición guardada", LoadPosition));
		_commands.Add(new dumbCommand("ShowPositions", "muestra las posiciones guardadas", ShowPositions));
		_commands.Add(new dumbCommand("RemovePosition", "borra la posición especificada", RemovePosition));
		_commands.Add(new dumbCommand("RemoveAllPositions", "Removes all positions from the list", RemoveAllPositions));
		_commands.Add(new dumbCommand("SetStamina", "Sets the player stamina", SetStamina));
		_commands.Add(new dumbCommand("flash", "te sentís re logi, eh (acelera al PJ)", Flash));
		_commands.Add(new dumbCommand("restart", "Reinicia el Nivel", loadLVL));
		_commands.Add(new dumbCommand("menu", "Vuelve al menú principal", loadMenu));
		_commands.Add(new dumbCommand("credits", "muestra los creditos", loadCredits));
	}
	private void Update()
	{
		if (!isOpened)
			return;
		else if (Input.GetKeyDown(KeyCode.UpArrow))
		{
				inputText.text = lastCommand;
		}
		else if (Input.GetKeyDown(KeyCode.Return))
		{
			lastCommand = inputText.text;
			ExecuteCommand();
		}
	}
	#endregion

	/// <summary>
	/// Shows the Console UI
	/// </summary>
	public static void Open()
	{
		Instance.isOpened = true;
		Instance.Container.SetActive(true);
		Instance.inputText.ActivateInputField();
		if (File.Exists("Assets/Resources/SavedPositions.json"))
		{
			Instance.savedPositions = ListToDictionary(jsonHelper.Load<Position>("Assets/Resources/SavedPositions.json"));
		}
		else
			Instance.savedPositions = new Dictionary<string, Vector3>();
	}
	/// <summary>
	/// Hides the Console UI
	/// </summary>
	public static void Close()
	{
		Instance.isOpened = false;
		Instance.Container.SetActive(false);

		jsonHelper.Save<Position>("Assets/Resources", DictionaryToList(Instance.savedPositions), "SavedPositions.json");
	}

	#region Private

	private static List<Position> DictionaryToList(Dictionary<string, Vector3> positions)
	{
		List<Position> result = new List<Position>();
		foreach (string key in positions.Keys)
		{
			result.Add(new Position
			{
				name = key,
				position = positions[key]
			});
		}
		return result;
	}

	private static Dictionary<string, Vector3> ListToDictionary(List<Position> positions)
	{
		Dictionary<string, Vector3> result = new Dictionary<string, Vector3>();
		foreach (Position p in positions)
		{
			result.Add(p.name, p.position);
		}
		return result;
	}
	/// <summary>
	/// Adds new text to the Console Body
	/// </summary>
	/// <param name="NewFeedBack">Text to add</param>
	void WriteFeedback(string NewFeedBack)
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
		string[] _commandParts = inputText.text.ToLower().Split(' ', ',');
		if (_commandParts.Length < 1)
			return;
		string _commandName = _commandParts[0];
		string[] _commandArgs = new string[0];
		if (_commandParts.Length > 1)
			_commandArgs = _commandParts.ToList().GetRange(1, _commandParts.Length - 1).ToArray();
		foreach (var x in _commands)
		{
			if (_commandName == x.name.ToLower())
			{
				x.Method.Invoke(_commandArgs);
				_commandRecognized = true;
				break;
			}
		}
		if (!_commandRecognized) WriteFeedback("Comand: " + _commandName + " not recognized");
		inputText.text = "";
	}

	#region Commands
	/// <summary>
	/// Shows all the command names and their description
	/// </summary>
	void Help(object[] args)
	{
		foreach (dumbCommand x in _commands)
		{
			WriteFeedback(x.name + ": " + x.description);
		}
	}

	public void GodMode(object[] args)
	{
		_commands[(int)Cmd.godMode].state = !_commands[(int)Cmd.godMode].state;
		//_playerBrain.GodMode = _commands[(int)Cmd.godMode].state;
		string _newState = _commands[(int)Cmd.godMode].state ? "on" : "off";
		WriteFeedback("GodMode: " + _newState);
	}

	void SavePosition(object[] args)
	{
		if (args.Length != 1)
		{
			WriteFeedback("This command only accepts 1 argument");
			return;
		}
		string _positionName = (string)args[0];
		savedPositions.Add(_positionName, player.transform.position);
		WriteFeedback("Position: " + _positionName + " saved to: " + player.transform.position);
	}

	void LoadPosition(object[] args)
	{
		if (args.Length != 1)
		{
			WriteFeedback("This command only accepts 1 argument");
			return;
		}
		string _positionName = (string)args[0];
		if (!savedPositions.ContainsKey(_positionName))
		{
			WriteFeedback("Position: " + _positionName + "not found");
			return;
		}
		Vector3 _position = savedPositions[_positionName];
		player.transform.position = _position;
		WriteFeedback("Position loaded to: " + _position);
	}

	void ShowPositions(object[] args)
	{
		string feedback = "";
		foreach (string s in savedPositions.Keys)
		{
			feedback += string.Format("Name: {0}, Position: {1}", s, savedPositions[s]);
		}
		if (feedback == "")
			WriteFeedback("No positions were found");
		else
			WriteFeedback("Positions: " + feedback);
	}

	void RemovePosition(object[] args)
	{
		if (args.Length != 1)
		{
			WriteFeedback("This command only accepts 1 argument");
			return;
		}
		string _positionName = (string)args[0];
		if (savedPositions.ContainsKey(_positionName))
		{
			WriteFeedback("Position: " + _positionName + "was removed");
			savedPositions.Remove(_positionName);
		}
		else
			WriteFeedback("Position: " + name + "not found");
	}

	void RemoveAllPositions(object[] args)
	{
		savedPositions = new Dictionary<string, Vector3>();
		WriteFeedback("All positions were removed");
	}

	void SetStamina(object[] args)
	{
		if (args.Length != 1)
		{
			WriteFeedback("This command only accepts 1 argument");
			return;
		}
		if(int.TryParse((string)args[0], out int _stamina))
		{
			player.Stamina.UpgradeMaxStamina(_stamina);
			player.Stamina.RefillCompletely();
			WriteFeedback("stamina upgraded to " + _stamina);
		}
		else
			WriteFeedback("Argument must be a number");
	}

	/// <summary>
	/// Multiplies the player's horizontal velocity
	/// </summary>
	/// <param name="multiplier">value to multiply player's horizontal velocity</param>
	public void Flash(object[] args)
	{

		if (!_commands[(int)Cmd.flash].state)
		{
			//_playerBody.flash = FlashMultiplier;
			WriteFeedback("Flash: On");
		}
		else
		{
			//_playerBody.flash = 1 / FlashMultiplier;
			WriteFeedback("Flash: Off");
		}
		_commands[(int)Cmd.flash].state = !_commands[(int)Cmd.flash].state;
	}

	void loadLVL(object[] args)
	{
		SceneManager.LoadScene(1);
	}
	void loadMenu(object[] args)
	{
		SceneManager.LoadScene(0);
	}
	void loadCredits(object[] args)
	{
		SceneManager.LoadScene(2);
	}
	#endregion

	#endregion
}
