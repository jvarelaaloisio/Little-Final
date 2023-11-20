using UnityEngine;

namespace Prefs.Runtime
{
    public class ColorPref : PrefUnit<Color>
    {
        public ColorPref(IPrefs prefs, string key, Color defaultValue)
            : base(prefs, key, defaultValue) { }

        public override void Load()
        {
            var htmlString = "#" + Prefs.GetString(key);
            ColorUtility.TryParseHtmlString(htmlString, out value);
        }

        public override void Save()
            => Prefs.SetString(key, ColorUtility.ToHtmlStringRGB(value));
    }
}