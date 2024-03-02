using Core.Providers;
using UnityEngine;

namespace DataProviders
{
    [CreateAssetMenu(menuName = "Data/Providers/Animator", fileName = "AnimatorProvider", order = 0)]
    public class AnimatorProvider : DataProvider<Animator> { }
}