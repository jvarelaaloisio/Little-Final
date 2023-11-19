using UnityEditor;

namespace Editor.Utils
{
    public class StringEditorPref : EditorPref<string>
    {
        public StringEditorPref(string key, string defaultValue = "")
            : base(key, defaultValue) { }

        public override void Load()
            => value = EditorPrefs.GetString(key);

        public override void Save()
            => EditorPrefs.SetString(key, value);
    }
}