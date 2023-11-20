using UnityEngine;

namespace Prefs
{
	public class PlayerPrefsAdapter : IPrefs
	{
		private const int True = 1;
		private const int False = 0;
		public bool HasKey(string key) => PlayerPrefs.HasKey(key);

		public void DeleteKey(string key) => PlayerPrefs.DeleteKey(key);

		public bool GetBool(string key) => PlayerPrefs.GetInt(key) == True;

		public void SetBool(string key, bool value) => PlayerPrefs.SetInt(key, value ? True : False);

		public int GetInt(string key) => PlayerPrefs.GetInt(key);

		public void SetInt(string key, int value) => PlayerPrefs.SetInt(key, value);

		public float GetFloat(string key) => PlayerPrefs.GetFloat(key);

		public void SetFloat(string key, float value) => PlayerPrefs.SetFloat(key, value);

		public string GetString(string key) => PlayerPrefs.GetString(key);

		public void SetString(string key, string value) => PlayerPrefs.SetString(key, value);
	}
}