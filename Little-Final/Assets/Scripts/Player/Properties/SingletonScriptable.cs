using UnityEngine;

namespace Player.Properties
{
	public abstract class SingletonScriptable<T> : ScriptableObject where T : ScriptableObject
	{
		private static T _instance;

		public static T Instance
		{
			get
			{
				if (!_instance)
				{
					_instance = Resources.Load<T>(typeof(T).Name);
				}

				if (_instance) return _instance;
				Debug.Log($"No {typeof(T).Name} Properties found in Resources folder" +
				          $"\nPlease make sure the file is named the same as the class");
				_instance = CreateInstance<T>();
				return _instance;
			}
		}
	}
}