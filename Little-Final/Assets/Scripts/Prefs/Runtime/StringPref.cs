namespace Prefs.Runtime
{
    public class StringPref : PrefUnit<string>
    {
        public StringPref(IPrefs prefs, string key, string defaultValue = "")
            : base(prefs, key, defaultValue) { }

        public override void Load()
            => value = Prefs.GetString(key);

        public override void Save()
            => Prefs.SetString(key, value);
    }
}