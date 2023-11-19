using UnityEditor;

namespace Editor.Utils
{
    public class BoolEditorPref : EditorPref<bool>
    {
        public BoolEditorPref(string key, bool defaultValue = false)
            : base(key, defaultValue) { }

        public override void Load()
            => value = EditorPrefs.GetBool(key);

        public override void Save()
            => EditorPrefs.SetBool(key, value);
    }
}