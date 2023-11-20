namespace Prefs
{
    public interface IPrefs
    {
        bool HasKey(string key);
        void DeleteKey(string key);
        bool GetBool(string key);
        void SetBool(string key, bool value);
        int GetInt(string key);
        void SetInt(string key, int value);
        float GetFloat(string key);
        void SetFloat(string key, float value);
        string GetString(string key);
        void SetString(string key, string value);
    }
}