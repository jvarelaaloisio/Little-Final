using Core.Data;
using UnityEditor;
using UnityEngine;

namespace Editor.Drawers
{
	[CustomPropertyDrawer(typeof(AnimatorParameter))]
	public class AnimatorParameterDrawer : PropertyDrawer
	{
		/// <inheritdoc />
		public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
		{
			var nameProperty = property.FindPropertyRelative("name");
			nameProperty.stringValue = EditorGUILayout.TextField(label ,nameProperty.stringValue);
			//TODO: Finish cleaning up this drawer
			// EditorGUILayout.PropertyField(nameProperty);
		}
	}
}
