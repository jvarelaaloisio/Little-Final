using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(MovingObject))]
public class MovingObjectEditor : Editor
{
	private const int buttonMaxWidth = 85;
	private const int maxPeriodTime = 120;
	MovingObject targetObject;
	private void OnEnable()
	{
		targetObject = (MovingObject)target;
	}
	public override void OnInspectorGUI()
	{
		GUILayout.BeginVertical();
		#region Period
		targetObject.period = EditorGUILayout.Slider("Period", targetObject.period, 1, maxPeriodTime);
		targetObject.period = Mathf.Round(targetObject.period);
		#endregion
		GUILayout.Space(5);
		#region Origin Field
		GUILayout.BeginHorizontal();
		targetObject.origin = EditorGUILayout.Vector3Field("Origin", targetObject.origin);
		if (GUILayout.Button("use current", GUILayout.MaxWidth(buttonMaxWidth)))
		{
			targetObject.origin = targetObject.transform.position;
		}
		GUILayout.EndHorizontal();
		#endregion
		#region Objective Field
		GUILayout.BeginHorizontal();
		targetObject.objective = EditorGUILayout.Vector3Field("Objective", targetObject.objective);
		if (GUILayout.Button("use current", GUILayout.MaxWidth(buttonMaxWidth)))
		{
			targetObject.objective = targetObject.transform.position;
		}
		GUILayout.EndHorizontal();
		#endregion
		if (GUILayout.Button("Swap Positions"))
		{
			Vector3 temp = targetObject.objective;
			targetObject.objective = targetObject.origin;
			targetObject.origin = temp;
		}

		GUILayout.EndVertical();
	}
	private void OnSceneGUI()
	{
		Handles.DrawBezier(targetObject.origin, targetObject.objective, targetObject.origin + Vector3.up, targetObject.objective + Vector3.down, Color.cyan, null, 3);
		Handles.DrawBezier(targetObject.origin, targetObject.objective, targetObject.origin + Vector3.down, targetObject.objective + Vector3.up, Color.magenta, null, 3);
		Handles.DrawBezier(targetObject.transform.position, targetObject.origin, targetObject.transform.position, targetObject.origin, Color.green, null, 2);
		Handles.DrawBezier(targetObject.transform.position, targetObject.objective, targetObject.transform.position, targetObject.objective, Color.red, null, 2);
		targetObject.origin = Handles.PositionHandle(targetObject.origin, targetObject.transform.rotation);
		targetObject.objective = Handles.PositionHandle(targetObject.objective, targetObject.transform.rotation);
	}
}
