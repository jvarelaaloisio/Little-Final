using System;
using System.IO;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.Reflection;
using System.Linq;

public class EW_Player : EditorWindow
{
	List<Type> stateTypes;
	PropertyHelper editorProperties;
	string propertiesFileName = "editor.json";
	string propertiesPath = "Assets/Editor/Properties";

	[MenuItem("Game Design/Player Editor")]
	public static void OpenWindow()
	{
		var window = GetWindow<EW_Player>();
		window.titleContent = new GUIContent("Player Editor");
		window.Enable();
		window.Show();
	}
	List<Type> GetPlayerStates()
	{
		List<Type> typesInAssembly = new List<Type>();
		Assembly[] assemblies = AppDomain.CurrentDomain.GetAssemblies();
		foreach (var a in assemblies)
		{
			typesInAssembly.AddRange(a.GetTypes());
		}
		List<Type> typesFiltered = typesInAssembly.FindAll(t => t.IsSubclassOf(typeof(PlayerState)));

		return typesFiltered;
	}

	private void Enable()
	{
		stateTypes = GetPlayerStates();
		if (!AssetDatabase.IsValidFolder(propertiesPath))
		{
			string[] folders = propertiesPath.Split('/');
			string actualFolder = folders[0];
			for (int i = 1; i < folders.Length; i++)
			{
				if (!AssetDatabase.IsValidFolder(actualFolder + folders[i]))
					AssetDatabase.CreateFolder(actualFolder, folders[i]);
				actualFolder += "/" + folders[i];
			}
		}
		if (!File.Exists(propertiesPath + "/" + propertiesFileName))
		{
			Debug.Log("Properties file not found");
			return;
		}

		editorProperties = new PropertyHelper(propertiesPath + "/" + propertiesFileName);
		Debug.Log(editorProperties.GetProperty("prueba").value);
	}
	private void OnGUI()
	{
		EditorGUILayout.Popup(new GUIContent("estado inicial"), 0, stateTypes.Select(t => t.Name).ToArray());
	}
}
