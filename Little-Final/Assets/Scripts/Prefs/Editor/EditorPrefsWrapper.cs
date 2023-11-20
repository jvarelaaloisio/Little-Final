using UnityEditor;

namespace Prefs.Editor
{
    public class EditorPrefsWrapper : IPrefs
    {
        private const int True = 1;
        private const int False = 0;
        public bool HasKey(string key) => EditorPrefs.HasKey(key);

        public void DeleteKey(string key) => EditorPrefs.DeleteKey(key);

        public bool GetBool(string key) => EditorPrefs.GetInt(key) == True;

        public void SetBool(string key, bool value) => EditorPrefs.SetInt(key, value ? True : False);

        public int GetInt(string key) => EditorPrefs.GetInt(key);

        public void SetInt(string key, int value) => EditorPrefs.SetInt(key, value);

        public float GetFloat(string key) => EditorPrefs.GetFloat(key);

        public void SetFloat(string key, float value) => EditorPrefs.SetFloat(key, value);

        public string GetString(string key) => EditorPrefs.GetString(key);

        public void SetString(string key, string value) => EditorPrefs.SetString(key, value);
    }
}