using System;
using System.IO;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.Linq;
using Player.Properties;

public class EW_Player : EditorWindow
{
	const int PANEL_WIDTH = 350;
	
	[MenuItem("Game Design/Player Editor")]
	public static void OpenWindow()
	{
		var window = GetWindow<EW_Player>();
		window.titleContent = new GUIContent("Player Editor");
		window.Show();
	}
	private void OnGUI()
	{
		maxSize = new Vector2(PANEL_WIDTH * 2 + 10, 925);
		minSize = new Vector2(PANEL_WIDTH * 2 + 10, 925);
		GUILayout.Label("Stats");
		Editor.CreateEditor(PP_Stats.Instance).OnInspectorGUI();
		GUILayout.Space(5);
GUILayout.BeginHorizontal();
	GUILayout.BeginVertical(GUILayout.MinWidth(PANEL_WIDTH), GUILayout.MaxWidth(PANEL_WIDTH));
		GUILayout.Label("Walk", EditorStyles.boldLabel);
		Editor.CreateEditor(PP_Walk.Instance).OnInspectorGUI();
	GUILayout.EndVertical();
	GUILayout.BeginVertical(GUILayout.MinWidth(PANEL_WIDTH),GUILayout.MaxWidth(PANEL_WIDTH));
		GUILayout.Label("Climb", EditorStyles.boldLabel);
		Editor.CreateEditor(PP_Climb.Instance).OnInspectorGUI();
	GUILayout.EndVertical();
GUILayout.EndHorizontal();
GUILayout.BeginHorizontal();
	GUILayout.BeginVertical(GUILayout.MinWidth(PANEL_WIDTH), GUILayout.MaxWidth(PANEL_WIDTH));
		GUILayout.Label("Jump", EditorStyles.boldLabel);
		Editor.CreateEditor(PP_Jump.Instance).OnInspectorGUI();
	GUILayout.EndVertical();
	GUILayout.BeginVertical(GUILayout.MinWidth(PANEL_WIDTH), GUILayout.MaxWidth(PANEL_WIDTH));
		GUILayout.Label("Glide", EditorStyles.boldLabel);
		Editor.CreateEditor(PP_Glide.Instance).OnInspectorGUI();
		GUILayout.Label("Fly", EditorStyles.boldLabel);
		Editor.CreateEditor(PP_Fly.Instance).OnInspectorGUI();
	GUILayout.EndVertical();
GUILayout.EndHorizontal();
	}
}
