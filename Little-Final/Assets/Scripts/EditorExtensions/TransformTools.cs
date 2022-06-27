using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace EditorExtensions
{
	public static class TransformTools
	{
		private const string NEW_PARENT_NAME = "New Parent";
		private const string CREATE_NEW_PARENT_UNDO_COMMAND = "Create New Parent";

		[MenuItem("GameObject/Reset Transform (Ignore children)", true, 49)]
		private static bool Validate_ResetTransform()
		{
			return (Selection.activeGameObject != null);
		}

		[MenuItem("GameObject/Reset Transform (Ignore children)", false, 49)]
		private static void ResetTransform()
		{
			GameObject selection = Selection.activeGameObject;
			Transform selectionTransform = selection.transform;
			CopyChildrenToArray(selectionTransform, out var children);
			SetNewParentOnTransformChildren(children, null);
			selectionTransform.transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
			selectionTransform.localScale = Vector3.one;
			SetNewParentOnTransformChildren(children, selectionTransform);

			void CopyChildrenToArray(Transform parent, out List<Transform> result)
			{
				result = new List<Transform>();
				foreach (Transform child in parent)
					result.Add(child);
			}
		}

		private static void SetNewParentOnTransformChildren(IEnumerable<Transform> children, Transform newParent)
		{
			foreach (Transform child in children)
			{
				child.parent = newParent;
			}
		}

		[MenuItem("GameObject/Sit Down", true, 48)]
		private static bool Validate_SitDownSelection()
		{
			return (Selection.activeGameObject != null);
		}

		[MenuItem("GameObject/Sit Down", false, 48)]
		private static void SitDownSelection()
		{
			var selection = Selection.gameObjects;
			foreach (GameObject current in selection)
			{
				var selectionTransform = current.transform;
				if (Physics.Raycast(selectionTransform.position,
									Vector3.down,
									out var hit,
									250))
				{
					selectionTransform.position = hit.point;
				}
			}
		}

		[MenuItem("GameObject/Set Parent to Null", true, 49)]
		private static bool Validate_MakeOrphan()
		{
			return (Selection.activeGameObject != null);
		}

		[MenuItem("GameObject/Set Parent to Null", false, 49)]
		private static void MakeOrphan()
		{
			var selection = Selection.gameObjects;
			foreach (GameObject current in selection)
			{
				current.transform.parent = null;
			}
		}

		[MenuItem("GameObject/Create Parent", true, 0)]
		private static bool Validate_CreateParent()
		{
			GameObject activeGameObject = Selection.activeGameObject;
			return (activeGameObject != null
					&& activeGameObject.name != NEW_PARENT_NAME);
		}

		[MenuItem("GameObject/Create Parent", false, 0)]
		private static void CreateParent()
		{
			var activeGameObject = Selection.activeGameObject;
			if (activeGameObject.name == NEW_PARENT_NAME)
				return;
			var selection = Selection.gameObjects;
			GameObject newParent = new GameObject(NEW_PARENT_NAME);
			Undo.RegisterCreatedObjectUndo(newParent, CREATE_NEW_PARENT_UNDO_COMMAND);
			Transform newParentTransform = newParent.transform;
			Transform activeTransform = activeGameObject.transform;
			newParentTransform.SetPositionAndRotation(activeTransform.position, activeTransform.rotation);

			foreach (GameObject current in selection)
			{
				Undo.SetTransformParent(current.transform, newParentTransform, CREATE_NEW_PARENT_UNDO_COMMAND);
			}

			Selection.activeGameObject = newParent.gameObject;
		}
	}
}