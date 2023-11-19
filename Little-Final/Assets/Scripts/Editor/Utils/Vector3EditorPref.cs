using UnityEditor;
using UnityEngine;

namespace Editor.Utils
{
    public class Vector3EditorPref : EditorPref<Vector3>
    {
        private const string xKeySufix = ".x";
        private const string yKeySufix = ".y";
        private const string zKeySufix = ".z";

        public Vector3EditorPref(string key, Vector3 defaultValue)
            : base(key, defaultValue) { }

        public override void Load()
        {
            var x = EditorPrefs.GetFloat(key + xKeySufix);
            var y = EditorPrefs.GetFloat(key + yKeySufix);
            var z = EditorPrefs.GetFloat(key + zKeySufix);
            value = new Vector3(x, y, z);
        }

        public override void Save()
        {
            EditorPrefs.SetFloat(key + xKeySufix, value.x);
            EditorPrefs.SetFloat(key + yKeySufix, value.y);
            EditorPrefs.SetFloat(key + zKeySufix, value.z);
        }
    }
}