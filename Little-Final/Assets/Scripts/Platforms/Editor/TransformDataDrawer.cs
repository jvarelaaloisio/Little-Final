using System;
using UnityEditor;
using UnityEngine;

namespace Platforms.Editor
{
	[CustomPropertyDrawer(typeof(TransformData))]
	public class TransformDataDrawer : PropertyDrawer
	{
		private const int LABEL_HEIGHT = 20;
		private const int LINE_HEIGHT = 25;
		private const int INDENT_LEVEL = 2;
		private const int POSITION = 0;
		private const int ROTATION = 1;
		private const int SCALE = 2;
		private const string COPY = "Copy";
		private const string PASTE = "Paste";
		private static readonly string[] Properties = {"position", "rotation", "scale"};
		private TransformData _dataCopyingBuffer;

		[MenuItem("CONTEXT/Transform/Copy to TransformData")]
		public static void Copy(MenuCommand command)
		{
			Transform current = command.context as Transform;

			TransformData transformData = new TransformData(current);
			CopyIntoTransformData(transformData);
		}

		private static void CopyIntoTransformData(TransformData current)
		{
			EditorGUIUtility.systemCopyBuffer = JsonUtility.ToJson(current);
		}

		public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
			=> property.isExpanded
				? LINE_HEIGHT * 3 + LABEL_HEIGHT
				: LABEL_HEIGHT;

		public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
		{
			if (Event.current != null)
				CheckForEvents(Event.current, position, property);
			EditorGUI.DrawRect(position, new Color(.1f, .1f, .1f, .25f));

			DrawFoldout(position, property, label);
			
			if (property.isExpanded)
			{
				// Don't make child fields be indented
				var indent = EditorGUI.indentLevel;
				EditorGUI.indentLevel = INDENT_LEVEL;

				Rect currentRect
					= new Rect(
						position.x,
						position.y,
						position.width,
						EditorGUI.GetPropertyHeight(property));
				foreach (var propertyName in Properties)
				{
					currentRect.y += LINE_HEIGHT;
					var currentProperty = property.FindPropertyRelative(propertyName);
					EditorGUI.PropertyField(currentRect, currentProperty);
				}

				// Set indent back to what it was
				EditorGUI.indentLevel = indent;
			}


			EditorGUI.EndProperty();
		}

		private static void DrawFoldout(Rect position, SerializedProperty property, GUIContent label)
		{
			var foldoutRect = position;
			foldoutRect.height = LABEL_HEIGHT;
			EditorGUI.BeginProperty(position, label, property);
			property.isExpanded
				= EditorGUI.Foldout(
					foldoutRect,
					property.isExpanded,
					label,
					true);
		}

		private void CheckForEvents(Event e, Rect position, SerializedProperty property)
		{
			if (e.type == EventType.MouseDown && e.button == 1 && position.Contains(e.mousePosition))
			{
				var context = new GenericMenu();
				context.AddItem(new GUIContent(COPY), false, CopyFromProperty, property);

				if (TryPaste())
					context.AddItem(new GUIContent(PASTE), false, PasteIntoProperty, property);
				else
					context.AddDisabledItem(new GUIContent(PASTE), false);

				context.ShowAsContext();
			}
			else if (
				e.control
				&& e.type == EventType.KeyDown
				&& position.Contains(e.mousePosition))
			{
				if (e.keyCode == KeyCode.C)
					CopyFromProperty(property);
				else if (e.keyCode == KeyCode.V && TryPaste())
				{
					PasteIntoProperty(property);
				}
			}
		}

		private void CopyFromProperty(object userData)
		{
			var currentProperty = userData as SerializedProperty;
			_dataCopyingBuffer = new TransformData
			{
				position = currentProperty.FindPropertyRelative(Properties[POSITION]).vector3Value,
				Rotation = Quaternion.Euler(currentProperty.FindPropertyRelative(Properties[ROTATION]).vector3Value),
				scale = currentProperty.FindPropertyRelative(Properties[SCALE]).vector3Value
			};
			CopyIntoTransformData(_dataCopyingBuffer);
		}

		private bool TryPaste()
		{
			try
			{
				_dataCopyingBuffer = JsonUtility.FromJson<TransformData>(EditorGUIUtility.systemCopyBuffer);
				return true;
			}
			catch (ArgumentException)
			{
				return false;
			}
		}

		private void PasteIntoProperty(object userData)
		{
			var currentProperty = userData as SerializedProperty;
			currentProperty.FindPropertyRelative(Properties[POSITION]).vector3Value
				= _dataCopyingBuffer.position;
			currentProperty.FindPropertyRelative(Properties[ROTATION]).vector3Value
				= _dataCopyingBuffer.Rotation.eulerAngles;
			currentProperty.FindPropertyRelative(Properties[SCALE]).vector3Value
				= _dataCopyingBuffer.scale;
			currentProperty.serializedObject.ApplyModifiedProperties();
		}
	}
}