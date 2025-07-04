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
			if (property.boxedValue is AnimatorParameter animatorParameter)
				animatorParameter.Name = EditorGUILayout.TextField(label, animatorParameter.Name);
			else
				EditorGUILayout.HelpBox($"{nameof(property)}'s boxed value is not of type {nameof(AnimatorParameter)}", MessageType.Error);
			//TODO: Finish cleaning up this drawer
			// EditorGUILayout.PropertyField(nameProperty);
		}
	}
}
