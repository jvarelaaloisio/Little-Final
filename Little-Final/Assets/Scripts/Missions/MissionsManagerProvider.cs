using Core.Providers;
using UnityEngine;

namespace Missions
{
    [CreateAssetMenu(menuName = "Data/Providers/Missions Manager", fileName = "MissionsManagerProvider", order = 0)]
    public class MissionsManagerProvider : DataProvider<MissionsManager> { }
}