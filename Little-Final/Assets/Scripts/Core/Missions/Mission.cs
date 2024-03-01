using System;
using UnityEngine;

namespace Missions
{
    [Serializable]
    public class Mission
    {
        [SerializeField] private string name;

        public Action<Mission> onComplete;
        public string Name => name;

        public Mission(string name)
        {
            this.name = name;
            onComplete = delegate { };
        }

        public void Complete()
        {
            onComplete(this);
        }
    }
}