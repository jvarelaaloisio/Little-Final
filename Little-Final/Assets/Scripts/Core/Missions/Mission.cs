using System;
using UnityEngine;

namespace Missions
{
    [Serializable]
    public class Mission
    {
        [SerializeField] private string name;

        public Action<Mission> onComplete;
        public Action<Mission> onDeliver;
        public string Name => name;

        public Mission(string name)
        {
            this.name = name;
            onComplete = delegate { };
            onDeliver = delegate { };
        }

        public void Complete()
        {
            onComplete(this);
        }

        public void Deliver()
        {
            onDeliver(this);
        }
    }
}