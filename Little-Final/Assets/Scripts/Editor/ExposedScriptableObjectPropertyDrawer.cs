using Core.Attributes;
using UnityEditor;
using UnityEngine;

namespace VarelaAloisio.Editor
{
	[CustomPropertyDrawer(typeof(ExposeScriptableObjectAttribute))]
	public class ExposedScriptableObjectPropertyDrawer : PropertyDrawer
	{
		private UnityEditor.Editor _editor = null;
		public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
		{
			// Draw label
			EditorGUI.PropertyField(position, property, label, true);
			
			if (property.objectReferenceValue)
			{
				var rect = position;
				rect.y += EditorGUIUtility.singleLineHeight;
				property.isExpanded = EditorGUI.Foldout(rect, property.isExpanded, GUIContent.none);
			}
 
			if (property.isExpanded)
			{
				EditorGUI.indentLevel++;
         
				if (!_editor)
					UnityEditor.Editor.CreateCachedEditor(property.objectReferenceValue, null, ref _editor);
				_editor.OnInspectorGUI();
         
				EditorGUI.indentLevel--;
			}
			else
				EditorGUILayout.Space(EditorGUIUtility.singleLineHeight);
		}
	}
}
