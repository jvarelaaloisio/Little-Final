using System;
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
			menu.AddItem(new GUIContent(ObjectNames.NicifyVariableName(nameof(ResetValue))), false, ResetValue, property);
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
			switch (property.propertyType)
			{
				case SerializedPropertyType.Generic:
					property.boxedValue = null;
					break;
				case SerializedPropertyType.Integer:
					property.intValue = 0;
					break;
				case SerializedPropertyType.Boolean:
					property.boolValue = false;
					break;
				case SerializedPropertyType.Float:
					property.floatValue = 0;
					break;
				case SerializedPropertyType.String:
					property.stringValue = "";
					break;
				case SerializedPropertyType.Color:
					property.colorValue = Color.white;
					break;
				case SerializedPropertyType.ObjectReference:
					property.objectReferenceValue = null;
					break;
				case SerializedPropertyType.LayerMask:
					property.intValue = 0;
					break;
				case SerializedPropertyType.Enum:
					property.enumValueIndex = 0;
					break;
				case SerializedPropertyType.Vector2:
					property.vector2Value = new Vector2(0, 0);
					break;
				case SerializedPropertyType.Vector3:
					property.vector3Value = new Vector3(0, 0, 0);
					break;
				case SerializedPropertyType.Vector4:
					property.vector4Value = new Vector4(0, 0, 0, 0);
					break;
				case SerializedPropertyType.Rect:
					property.rectValue = new Rect(0, 0, 0, 0);
					break;
				case SerializedPropertyType.ArraySize:
					property.arraySize = 0;
					break;
				case SerializedPropertyType.Character:
					property.stringValue = "";
					break;
				case SerializedPropertyType.AnimationCurve:
					property.animationCurveValue = AnimationCurve.Constant(0, 1, 1);
					break;
				case SerializedPropertyType.Bounds:
					property.boundsValue = new Bounds(Vector3.zero, Vector3.zero);
					break;
				case SerializedPropertyType.Gradient:
					property.gradientValue = new Gradient();
					break;
				case SerializedPropertyType.Quaternion:
					property.quaternionValue = Quaternion.identity;
					break;
				case SerializedPropertyType.ExposedReference:
					property.exposedReferenceValue = null;
					break;
				case SerializedPropertyType.Vector2Int:
					property.vector2IntValue = new Vector2Int(0, 0);
					break;
				case SerializedPropertyType.Vector3Int:
					property.vector3IntValue = new Vector3Int(0, 0, 0);
					break;
				case SerializedPropertyType.RectInt:
					property.rectIntValue = new RectInt(0, 0, 0, 0);
					break;
				case SerializedPropertyType.BoundsInt:
					property.boundsIntValue = new BoundsInt(Vector3Int.zero, Vector3Int.zero);
					break;
				case SerializedPropertyType.ManagedReference:
					property.managedReferenceValue = null;
					break;
				case SerializedPropertyType.Hash128:
					property.hash128Value = new Hash128();
					break;
			}
			property.serializedObject.ApplyModifiedProperties();
		}
	}
}