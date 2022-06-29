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
     
			// Draw foldout arrow
			if (property.objectReferenceValue != null)
			{
				property.isExpanded = EditorGUI.Foldout(position, property.isExpanded, GUIContent.none);
			}
 
			// Draw foldout properties
			if (property.isExpanded)
			{
				// Make child fields be indented
				EditorGUI.indentLevel++;
         
				// Draw object properties
				if (!_editor)
					UnityEditor.Editor.CreateCachedEditor(property.objectReferenceValue, null, ref _editor);
				_editor.OnInspectorGUI();
         
				// Set indent back to what it was
				EditorGUI.indentLevel--;
			}
		}
	}
}
