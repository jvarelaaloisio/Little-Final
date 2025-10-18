using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace VarelaAloisio.Editor
{
	[CustomEditor(typeof(MonoBehaviour), true, isFallback = true)]
	public class MonoBehaviourEditor : UnityEditor.Editor
	{
		private readonly List<UnityEditor.Editor> _soEditors = new List<UnityEditor.Editor>();
		private readonly List<ScriptableObject> _scriptableObjects = new List<ScriptableObject>();
		private Vector2 _scrollPosition;

		private void OnEnable()
			=> GetAllScriptableObjects();

		private void OnDisable()
		{
			foreach (var editor in _soEditors.Where(editor => editor))
				DestroyImmediate(editor);

			_soEditors.Clear();
			_scriptableObjects.Clear();
		}

		public override void OnInspectorGUI()
		{
			EditorGUI.BeginChangeCheck();
			base.OnInspectorGUI();
			if (EditorGUI.EndChangeCheck())
			{
				GetAllScriptableObjects();
				Repaint();
			}
		}

		public override bool HasPreviewGUI()
			=> targets.Length <= 1 && _scriptableObjects.Count > 0;

		public override void OnPreviewGUI(Rect r, GUIStyle background)
		{
			if (_scriptableObjects.Count == 0)
				return;

			UpdateEditors();

			float totalHeight = 0;
			foreach (var editor in _soEditors)
			{
				if (editor == null) continue;
				totalHeight += 20; // Label height
				var property = editor.serializedObject.GetIterator();
				if (property.NextVisible(true))
				{
					do
					{
						totalHeight += EditorGUI.GetPropertyHeight(property, true) + EditorGUIUtility.standardVerticalSpacing;
					} while (property.NextVisible(false));
				}
				totalHeight += 14; // Separator and spacing
			}
			
			var viewRect = new Rect(0, 0, r.width - 20, totalHeight);
			_scrollPosition = GUI.BeginScrollView(r, _scrollPosition, viewRect);

			float yPosition = 0;
			for (var i = 0; i < _soEditors.Count; i++)
			{
				var editor = _soEditors[i];
				if (editor == null) continue;

				GUI.Label(new Rect(0, yPosition, viewRect.width, 20), editor.target.name, EditorStyles.boldLabel);
				yPosition += 20;

				editor.serializedObject.Update();
				
				var property = editor.serializedObject.GetIterator();
				if (property.NextVisible(true))
				{
					do
					{
						float height = EditorGUI.GetPropertyHeight(property, true);
						EditorGUI.PropertyField(new Rect(0, yPosition, viewRect.width, height), property, true);
						yPosition += height + EditorGUIUtility.standardVerticalSpacing;
					} while (property.NextVisible(false));
				}

				editor.serializedObject.ApplyModifiedProperties();

				if (i < _soEditors.Count - 1)
				{
					yPosition += 5;
					GUI.Label(new Rect(0, yPosition, viewRect.width, 2), "", GUI.skin.horizontalSlider);
					yPosition += 7;
				}
			}

			GUI.EndScrollView(true);
		}

		private void GetAllScriptableObjects()
		{
			_scriptableObjects.Clear();
			SerializedProperty property = serializedObject.GetIterator();
			property.NextVisible(true); // Skip script property
			while (property.NextVisible(false))
			{
				if (property.propertyType == SerializedPropertyType.ObjectReference &&
				    property.objectReferenceValue is ScriptableObject scriptableObject &&
				    scriptableObject != null)
				{
					_scriptableObjects.Add(scriptableObject);
				}
			}
		}

		private void UpdateEditors()
		{
			if (_soEditors.Count == _scriptableObjects.Count)
			{
				bool needsUpdate = false;
				for (int i = 0; i < _soEditors.Count; i++)
				{
					if (_soEditors[i] == null || _soEditors[i].target != _scriptableObjects[i])
					{
						needsUpdate = true;
						break;
					}
				}

				if (!needsUpdate) return;
			}

			foreach (var editor in _soEditors)
			{
				if (editor != null)
					DestroyImmediate(editor);
			}

			_soEditors.Clear();

			foreach (var so in _scriptableObjects)
			{
				_soEditors.Add(CreateEditor(so));
			}
		}
	}
}
