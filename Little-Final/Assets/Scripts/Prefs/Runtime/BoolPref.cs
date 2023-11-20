namespace Prefs.Runtime
{
    public class BoolPref : PrefUnit<bool>
    {
        public BoolPref(IPrefs prefs, string key, bool defaultValue = false)
            : base(prefs, key, defaultValue) { }

        public override void Load()
            => value = Prefs.GetBool(key);

        public override void Save()
            => Prefs.SetBool(key, value);
    }
}