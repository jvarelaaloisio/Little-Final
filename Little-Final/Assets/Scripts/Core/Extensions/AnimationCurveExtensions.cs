using System.Linq;
using UnityEngine;

namespace Core.Extensions
{
    public static class AnimationCurveExtensions
    {
        public static float Duration(this AnimationCurve animationCurve)
        {
            if (animationCurve == null
                || animationCurve.length < 2)
                return 0;

            return animationCurve.keys.Last().time - animationCurve.keys.First().time;
        }
    }
}
