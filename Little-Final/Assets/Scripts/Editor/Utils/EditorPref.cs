using UnityEditor;

namespace Editor.Utils
{
    public abstract class EditorPref<T>
    {
        public T value;
        public readonly string key;
        private readonly T _defaultValue;

        protected EditorPref(string key, T defaultValue)
        {
            this.key = key;
            _defaultValue = defaultValue;
            Reset();
        }

        /// <summary>
        /// Checks if the editor prefs has this pref's key
        /// </summary>
        public bool Exists => EditorPrefs.HasKey(key);

        /// <summary>
        /// Sets the value back to default
        /// </summary>
        /// <param name="defaultValue"></param>
        public virtual void Reset()
            => value = _defaultValue;

        /// <summary>
        /// Deletes this pref's key from editorPrefs
        /// </summary>
        public virtual void DeleteKey()
            => EditorPrefs.DeleteKey(key);

        /// <summary>
        /// Checks if the key exists in the editorPrefs before loading.
        /// </summary>
        /// <returns>True if the key exists</returns>
        public virtual bool TryLoad()
        {
            if (!Exists)
                return false;
            Load();
            return true;
        }

        /// <summary>
        /// Gets the value stored in editorPrefs
        /// </summary>
        public abstract void Load();

        /// <summary>
        /// Saves the value into the editorPrefs
        /// </summary>
        public abstract void Save();

        public static implicit operator T(EditorPref<T> editorPref) => editorPref.value;
    }
}