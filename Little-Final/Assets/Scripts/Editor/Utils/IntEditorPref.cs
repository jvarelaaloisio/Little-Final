using UnityEditor;

namespace Editor.Utils
{
    public class IntEditorPref : EditorPref<int>
    {
        public IntEditorPref(string key, int defaultValue = 1)
            : base(key, defaultValue) { }

        public override void Load()
            => value = EditorPrefs.GetInt(key);

        public override void Save()
            => EditorPrefs.SetInt(key, value);
    }
}