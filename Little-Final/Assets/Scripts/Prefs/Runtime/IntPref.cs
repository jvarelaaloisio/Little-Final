namespace Prefs.Runtime
{
    public class IntPref : PrefUnit<int>
    {
        public IntPref(IPrefs prefs, string key, int defaultValue = 1)
            : base(prefs, key, defaultValue) { }

        public override void Load()
            => value = Prefs.GetInt(key);

        public override void Save()
            => Prefs.SetInt(key, value);
    }
}