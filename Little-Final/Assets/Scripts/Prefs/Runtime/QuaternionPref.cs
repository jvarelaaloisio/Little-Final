using UnityEngine;

namespace Prefs.Runtime
{
    public class QuaternionPref : PrefUnit<Quaternion>
    {
        private const string xKeySufix = ".x";
        private const string yKeySufix = ".y";
        private const string zKeySufix = ".z";
        private const string wKeySufix = ".w";

        public QuaternionPref(IPrefs prefs, string key, Quaternion defaultValue)
            : base(prefs, key, defaultValue) { }

        public override void Load()
        {
            var x = Prefs.GetFloat(key + xKeySufix);
            var y = Prefs.GetFloat(key + yKeySufix);
            var z = Prefs.GetFloat(key + zKeySufix);
            var w = Prefs.GetFloat(key + wKeySufix);
            value = new Quaternion(x, y, z, w);
        }

        public override void Save()
        {
            Prefs.SetFloat(key + xKeySufix, value.x);
            Prefs.SetFloat(key + yKeySufix, value.y);
            Prefs.SetFloat(key + zKeySufix, value.z);
            Prefs.SetFloat(key + wKeySufix, value.w);
        }
    }
}