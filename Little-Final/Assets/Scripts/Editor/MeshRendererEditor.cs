using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(MeshRenderer)), CanEditMultipleObjects]
public class MeshRendererEditor : UnityEditor.Editor
{
	List<MeshRenderer> _targets;
	private void OnEnable()
	{
		_targets = new List<MeshRenderer>();
	}
	public override void OnInspectorGUI()
	{
		base.OnInspectorGUI();
		for (int i = 0; i < targets.Length; i++)
		{
			_targets.Add((MeshRenderer)targets[i]);
		}
		GUILayout.BeginHorizontal();
		if (GUILayout.Button("On"))
		{
			_targets.ForEach((MeshRenderer mesh) => mesh.enabled = true);
		}
		else if (GUILayout.Button("Off"))
		{
			_targets.ForEach((MeshRenderer mesh) => mesh.enabled = false);
		}
		GUILayout.EndHorizontal();
	}
}
