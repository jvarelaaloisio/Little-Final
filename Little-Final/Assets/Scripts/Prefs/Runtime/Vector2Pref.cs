using UnityEngine;

namespace Prefs.Runtime
{
    public class Vector2Pref : PrefUnit<Vector2>
    {
        private const string xKeySufix = ".x";
        private const string yKeySufix = ".y";

        public Vector2Pref(IPrefs prefs, string key, Vector3 defaultValue)
            : base(prefs, key, defaultValue) { }

        public override void Load()
        {
            var x = Prefs.GetFloat(key + xKeySufix);
            var y = Prefs.GetFloat(key + yKeySufix);
            value = new Vector2(x, y);
        }

        public override void Save()
        {
            Prefs.SetFloat(key + xKeySufix, value.x);
            Prefs.SetFloat(key + yKeySufix, value.y);
        }
    }
}