using UnityEditor;

namespace Editor.Utils
{
    public class FloatEditorPref : EditorPref<float>
    {
        public FloatEditorPref(string key, float defaultValue = 1f)
            : base(key, defaultValue) { }

        public override void Load()
            => value = EditorPrefs.GetFloat(key);

        public override void Save()
            => EditorPrefs.SetFloat(key, value);
    }
}