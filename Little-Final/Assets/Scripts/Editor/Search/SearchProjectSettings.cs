using System;
using Prefs.Editor;
using Prefs.Runtime;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine.Search;

namespace Editor.Search
{
	public class SearchProjectSettings
	{
		private const string PrefsKeyPrefix = "Search";
		private static readonly EditorPrefsWrapper EditorPrefs = new();
		
		public static SerializablePref<SearchFlags, int> SearchFlags { get; }
			= new(nameof(SearchFlags),
			      new IntPref(EditorPrefs,
			                  PrefsKeyPrefix + "SearchFlags",
			                  (int)UnityEditor.Search.SearchFlags.None),
			      unit => (SearchFlags)unit.value);

		public static SerializablePref<SearchViewFlags, int> SearchViewFlags { get; }
			= new(nameof(SearchViewFlags),
			      new IntPref(EditorPrefs,
			                  PrefsKeyPrefix + "SearchViewFlags",
			                  (int)UnityEngine.Search.SearchViewFlags.None),
			      unit => (SearchViewFlags)unit.value);

		[SettingsProvider]
		public static SettingsProvider CreateToolbarsSettingsProvider()
		{
			var provider = new SettingsProvider("Project/Search Interfaces", SettingsScope.Project)
			               {
				               label = "Search Interfaces",
				               guiHandler = HandleGUI,

				               keywords = new[] { "Search", "Interfaces" }
			               };

			LoadPrefs();
			return provider;
		}
		private static void LoadPrefs()
		{
			SearchFlags.Load();
		}

		private static void HandleGUI(string searchContext)
		{
			EditorGUIUtility.labelWidth = 200;
			SearchFlags.OnGUI((int)(SearchFlags)EditorGUILayout.EnumFlagsField(SearchFlags.Label, SearchFlags));
			SearchViewFlags.OnGUI((int)(SearchViewFlags)EditorGUILayout.EnumFlagsField(SearchViewFlags.Label, SearchViewFlags));
		}
	}

	public class SerializablePref<TRuntime, TPref>
	{
		private readonly Func<PrefUnit<TPref>, TRuntime> _cast;
		public PrefUnit<TPref> Unit { get; }
		public string Label { get; }

		public SerializablePref(string fieldName, PrefUnit<TPref> prefUnit, Func<PrefUnit<TPref>, TRuntime> cast)
		{
			Unit = prefUnit;
			_cast = cast;
			Label = ObjectNames.NicifyVariableName(fieldName);
		}

		public void Load()
			=> Unit.Load();

		public static implicit operator TRuntime(SerializablePref<TRuntime, TPref> original) => original._cast(original.Unit);

		public void OnGUI(TPref newValue)
		{
			if (newValue.Equals(Unit.value))
				return;
			Unit.value = newValue;
			Unit.Save();
		}
	}
}