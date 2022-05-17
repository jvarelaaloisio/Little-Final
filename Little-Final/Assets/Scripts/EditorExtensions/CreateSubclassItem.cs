using System;
using System.IO;
using UnityEditor;
using UnityEditor.ProjectWindowCallback;
using UnityEngine;
using Object = UnityEngine.Object;

namespace EditorExtensions
{
	public static class CreateSubclassItem
	{
		private const string SUBCLASS_NAME_SUFFIX = "_Subclass";

		[MenuItem("Assets/Create/C# Subclass", priority = 81)]
		public static void CreateSubclass(MenuCommand context)
		{
			MonoScript selection = Selection.activeObject as MonoScript;
			Type T = selection.GetClass();
			string baseClassName = selection.name;
			string newClassName = baseClassName + SUBCLASS_NAME_SUFFIX;
			string nameSpace = T.Namespace;
			GetFolderFromSelection(selection, $"/{newClassName}.cs", out string newPath);

			ProjectWindowUtil.StartNameEditingIfProjectWindowExists(
																	0,
																	ScriptableObject
																		.CreateInstance<EndNameActionForScript>(),
																	newPath,
																	AssetPreview
																		.GetMiniTypeThumbnail(typeof(MonoScript)),
																	$"{nameSpace}|{baseClassName}");
		}

		private static void GetFolderFromSelection(Object selection, string pathSuffix, out string newPath)
		{
			string basePath = AssetDatabase.GetAssetPath(selection);
			string[] basePathSplit = basePath.Split('/');
			newPath = basePathSplit[0];
			for (int i = 1; i < basePathSplit.Length - 1; i++)
				newPath += "/" + basePathSplit[i];

			newPath += pathSuffix;
		}

		[MenuItem("Assets/Create/C# Subclass", true, priority = 81)]
		public static bool CreateSubclass()
		{
			var objects = Selection.objects;
			if (objects.Length < 1)
				return false;
			var selection = objects[0];
			return objects.Length < 2
					&& selection is MonoScript script
					&& script.GetClass() != null
					&& !script.GetClass().IsSealed;
		}

		internal class EndNameActionForScript : EndNameEditAction
		{
			public override void Action(int instanceId, string pathName, string nameSpaceAndBaseClassName)
			{
				var pathSplit = pathName.Split('/');

				var className = pathSplit[pathSplit.Length - 1];
				className = className.Remove(className.Length - 3);

				var data = nameSpaceAndBaseClassName.Split('|');
				var nameSpace = data[0];
				foreach (var s in data)
				{
					Debug.Log(s);
				}

				var baseClassName = data[1];
				string fileData = "using UnityEngine;\n\n";
				bool isInNamespace = !string.IsNullOrEmpty(nameSpace);
				if (isInNamespace) fileData += "namespace " + nameSpace + "\n{\n\t";
				fileData += "public class " + className + " : " + baseClassName;
				fileData += isInNamespace ? "\n\t{\n\t}\n}" : "\n{\n}";
				var file = File.CreateText(pathName);
				file.Write(fileData);
				file.Dispose();
				AssetDatabase.Refresh();
			}
		}
	}
}