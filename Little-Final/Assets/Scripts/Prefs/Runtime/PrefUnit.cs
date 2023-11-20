namespace Prefs.Runtime
{
    /// <summary>
    /// Base class for different units that hold prefs-stored values
    /// </summary>
    /// <typeparam name="T">The value being hold by this class</typeparam>
    public abstract class PrefUnit<T>
    {
        public T value;
        protected readonly IPrefs Prefs;
        public readonly string key;
        private readonly T _defaultValue;

        protected PrefUnit(IPrefs prefs, string key, T defaultValue)
        {
            Prefs = prefs;
            this.key = key;
            _defaultValue = defaultValue;
            Reset();
        }

        /// <summary>
        /// Checks if the editor prefs has this pref's key
        /// </summary>
        public bool Exists => Prefs.HasKey(key);

        /// <summary>
        /// Sets the value back to default
        /// </summary>
        /// <param name="defaultValue"></param>
        public virtual void Reset()
            => value = _defaultValue;

        /// <summary>
        /// Deletes this pref's key from prefs
        /// </summary>
        public virtual void DeleteKey()
            => Prefs.DeleteKey(key);

        /// <summary>
        /// Checks if the key exists in the prefs before loading.
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
        /// Gets the value stored in prefs
        /// </summary>
        public abstract void Load();

        /// <summary>
        /// Saves the value into the prefs
        /// </summary>
        public abstract void Save();

        public static implicit operator T(PrefUnit<T> prefUnit) => prefUnit.value;
    }
}