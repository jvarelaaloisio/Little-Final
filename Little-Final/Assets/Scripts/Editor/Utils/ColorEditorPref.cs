using UnityEditor;
using UnityEngine;

namespace Editor.Utils
{
    public class ColorEditorPref : EditorPref<Color>
    {
        public ColorEditorPref(string key, Color defaultValue)
            : base(key, defaultValue) { }

        public override void Load()
        {
            var htmlString = "#" + EditorPrefs.GetString(key);
            ColorUtility.TryParseHtmlString(htmlString, out value);
        }

        public override void Save()
            => EditorPrefs.SetString(key, ColorUtility.ToHtmlStringRGB(value));
    }
}