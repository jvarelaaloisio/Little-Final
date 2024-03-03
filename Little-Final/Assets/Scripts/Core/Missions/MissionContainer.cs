using UnityEngine;

namespace Missions
{
    public abstract class MissionContainer : ScriptableObject
    {
        public abstract Mission Get { get; }
        public virtual Mission Add()
        {
            return Get;
        }
    }
}