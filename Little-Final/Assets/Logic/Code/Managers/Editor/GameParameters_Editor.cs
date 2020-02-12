using UnityEditor;

[CustomEditor(typeof(GameParameters), true)]
public class GameParameters_Editor : Editor
{
	SerializedProperty playerProperties;

	private void OnEnable()
	{
		playerProperties = serializedObject.FindProperty("playerProperties");
	}

	public override void OnInspectorGUI()
	{
		serializedObject.Update();
		EditorGUILayout.PropertyField(playerProperties);
		serializedObject.ApplyModifiedProperties();
	}
}
