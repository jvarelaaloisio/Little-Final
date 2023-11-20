namespace Prefs.Runtime
{
    public class FloatPref : PrefUnit<float>
    {
        public FloatPref(IPrefs prefs, string key, float defaultValue = 1f)
            : base(prefs, key, defaultValue) { }

        public override void Load()
            => value = Prefs.GetFloat(key);

        public override void Save()
            => Prefs.SetFloat(key, value);
    }
}