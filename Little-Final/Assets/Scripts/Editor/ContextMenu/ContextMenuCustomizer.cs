using UnityEditor;
using UnityEngine;

namespace Editor.ContextMenu
{
	[InitializeOnLoad]
	public static class ContextMenuCustomizer
	{
		static ContextMenuCustomizer()
		{
			EditorApplication.contextualPropertyMenu -= HandleContextMenu;
			EditorApplication.contextualPropertyMenu += HandleContextMenu;
		}

		private static void HandleContextMenu(GenericMenu menu, SerializedProperty property)
		{
			if (property.propertyType is not SerializedPropertyType.ObjectReference)
				return;
			menu.AddItem(new GUIContent(ObjectNames.NicifyVariableName(nameof(SetToNone))), false, SetToNone, property);
		}

		private static void SetToNone(object data)
		{
			if (data is not SerializedProperty property)
				return;
			Undo.RegisterCompleteObjectUndo(property.serializedObject.targetObject, $"Set {property.serializedObject.targetObject.name}.{property.name} to None");
			property.objectReferenceValue = null;
			property.serializedObject.ApplyModifiedProperties();
		}

		private static void ResetValue(object data)
		{
			if (data is not SerializedProperty property)
				return;
			property.
		}
	}
}