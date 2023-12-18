using Editor.Utils;
using Prefs.Editor;
using Prefs.Runtime;
using UnityEditor;

namespace Editor.Toolbar
{
    public static class ToolbarProjectSettings
    {
        private const string PrefsKeyPrefix = "Toolbar";
        private static readonly EditorPrefsWrapper EditorPrefs = new();
        
        private const string BootScenePathKey = PrefsKeyPrefix + "BootScenePath";
        public static StringPref BootScenePath { get; } = new(EditorPrefs, BootScenePathKey, "Assets/Scenes/Menus/BootScene.unity");
        private static readonly string BootScenePathLabel = PascalCaseSplitter.SplitPascalCase(nameof(BootScenePath));

        [SettingsProvider]
        public static SettingsProvider CreateToolbarsSettingsProvider()
        {
            var provider = new SettingsProvider("Project/Toolbar", SettingsScope.Project)
                           {
                               label = "Toolbar Settings",
                               guiHandler = GUIHandler,

                               keywords = new[] { "Toolbar", "Setting" }
                           };

            LoadPrefs();
            return provider;
        }

        private static void LoadPrefs()
        {
            BootScenePath.Load();
        }

        private static void GUIHandler(string searchContext)
        {
            EditorGUIUtility.labelWidth = 200;
            var tempBootScenePath = EditorGUILayout.TextField(BootScenePathLabel, BootScenePath);

            if (tempBootScenePath != BootScenePath.value)
            {
                BootScenePath.value = tempBootScenePath;
                BootScenePath.Save();
            }
        }
    }
}