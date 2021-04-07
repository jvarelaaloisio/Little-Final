using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Platforms;
using Unity.EditorCoroutines.Editor;
using UnityEditor;
using UnityEngine;

namespace Editors.World_Windows
{
	public class PrefabCreatorWindow : EditorWindow
	{
		private GameObject _baseObject;
		private Editor _meshEditor;
		private string _newPrefabName = "";
		private string _objectFilter = "";
		private string _prefabPath = "Assets/Prefabs";
		private EditorCoroutine _updateGOsCoroutine;

		private List<GameObject> _subjectsToReplace = new List<GameObject>();

		[MenuItem("Tools/Prefab Creator")]
		public static void OpenWindow()
		{
			var w = GetWindow<PrefabCreatorWindow>();
			w._updateGOsCoroutine = EditorCoroutineUtility.StartCoroutine(w.UpdateGOs(), w);
			w.Show();
		}

		private void OnDisable()
		{
			EditorCoroutineUtility.StopCoroutine(_updateGOsCoroutine);
		}

		private void OnGUI()
		{
			var temp = (GameObject) EditorGUILayout.ObjectField(
				"base object",
				_baseObject,
				typeof(GameObject),
				true);
			if (!temp)
				return;
			DrawMeshPreview(temp);
			if (temp != _baseObject)
			{
				_baseObject = temp;
				_newPrefabName = _baseObject.name;
				_objectFilter = _newPrefabName;
			}

			// asdf = EditorGUILayout.Knob(Vector2.one * 50, asdf, 0, 1, "adf", Color.black, Color.blue, true);
			_newPrefabName = EditorGUILayout.TextField("Name", _newPrefabName);

			_objectFilter = EditorGUILayout.TextField(
				new GUIContent(
					"Filter",
					"This will be used to filter\n" +
					"all the gameObjects in this scene\n" +
					"that will be replaced with the Prefab"),
				_objectFilter);
			GUILayout.Label(_subjectsToReplace.Count + " GOs will be replaced");
			EditorGUILayout.BeginHorizontal(GUILayout.Width(position.width - 5));
			GUILayout.Label("Path", GUILayout.Width(40));
			var textFieldStyle = new GUIStyle(GUI.skin.textField)
			{
				alignment = TextAnchor.MiddleRight
			};
			_prefabPath = EditorGUILayout.TextField(_prefabPath, textFieldStyle);
			GUILayout.Label($"/{_newPrefabName}.prefab");
			EditorGUILayout.EndHorizontal();
			if (GUILayout.Button("Save Prefab and Replace") && AssetDatabase.IsValidFolder(_prefabPath))
			{
				PrefabUtility.SaveAsPrefabAssetAndConnect(
					_baseObject,
					$"{_prefabPath}/{_newPrefabName}.prefab",
					InteractionMode.UserAction,
					out var saveSuccess);
				Debug.Log(_newPrefabName + " " + (saveSuccess ? "saved successfully" : "failed to save"));
			}
			else if (GUILayout.Button("Replace All") && _subjectsToReplace.Count > 0)
			{
				for (int i = 0; i < _subjectsToReplace.Count; i++)
				{
					var subject = _subjectsToReplace[i];
					var subjectTransform = subject.transform;
					var parentTransform = subjectTransform.parent;
					Debug.Log(subject.name);
					var newSubject = PrefabUtility.InstantiatePrefab(_baseObject, parentTransform) as GameObject;
					newSubject.name = subject.name;
					Transform newTransform = newSubject.transform;
					newTransform.localPosition = subjectTransform.localPosition;
					newTransform.localRotation = subjectTransform.localRotation;
					newTransform.localScale = subjectTransform.localScale;
					DestroyImmediate(subject, true);
					Selection.activeGameObject = newSubject;
				}
			}
		}

		private void DrawMeshPreview(in GameObject tempObject)
		{
			Mesh mesh;
			if (tempObject.TryGetComponent<MeshFilter>(out var meshFilter))
				mesh = meshFilter.sharedMesh;
			else if (tempObject.TryGetComponent(out SkinnedMeshRenderer skinnedMeshRenderer))
				mesh = skinnedMeshRenderer.sharedMesh;
			else
				return;
			if (!_meshEditor || tempObject != _baseObject)
				_meshEditor = Editor.CreateEditor(mesh);

			float size = position.width;
			_meshEditor.OnPreviewGUI(GUILayoutUtility.GetRect(size, size * 2 / 4), GUIStyle.none);
		}

		private IEnumerator UpdateGOs()
		{
			while (true)
			{
				yield return new WaitForSeconds(.25f);
				if (_objectFilter == "")
					continue;
				var objects = FindObjectsOfType<GameObject>();
				_subjectsToReplace = objects.Where(go => go.name.Contains(_objectFilter)).ToList();
			}
		}
	}
}