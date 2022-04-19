using UnityEngine;

public abstract class MonobehaviourSingleton<T> : MonoBehaviour where T : MonoBehaviour
{
    public static bool IsAwake => _instance != null;

    public static T Instance
    {
        get
        {
            if (_instance != null) return _instance;

            _instance = (T) FindObjectOfType(typeof(T));
            if (_instance != null) return _instance;

            var goName = typeof(T).ToString();
            var go = GameObject.Find(goName);
            if (go == null) go = new GameObject(goName);

            _instance = go.AddComponent<T>();

            return _instance;
        }
        protected set => _instance = value;
    }

    private static T _instance = null;

    public virtual void OnApplicationQuit()
    {
        _instance = null;
    }
}