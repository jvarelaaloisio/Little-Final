using UnityEngine;

namespace Prefs.Runtime
{
    public class Vector3Pref : PrefUnit<Vector3>
    {
        private const string xKeySufix = ".x";
        private const string yKeySufix = ".y";
        private const string zKeySufix = ".z";

        public Vector3Pref(IPrefs prefs, string key, Vector3 defaultValue)
            : base(prefs, key, defaultValue) { }

        public override void Load()
        {
            var x = Prefs.GetFloat(key + xKeySufix);
            var y = Prefs.GetFloat(key + yKeySufix);
            var z = Prefs.GetFloat(key + zKeySufix);
            value = new Vector3(x, y, z);
        }

        public override void Save()
        {
            Prefs.SetFloat(key + xKeySufix, value.x);
            Prefs.SetFloat(key + yKeySufix, value.y);
            Prefs.SetFloat(key + zKeySufix, value.z);
        }
    }
}