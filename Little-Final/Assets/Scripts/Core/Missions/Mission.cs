using System;
using UnityEngine;

namespace Core.Missions
{
    [Serializable]
    public class Mission
    {
        [SerializeField] private string name;

        public Action<Mission> onComplete;
        public Action<Mission> onFinish;
        public string Name => name;

        public Mission(string name)
        {
            this.name = name;
            onComplete = delegate { };
            onFinish = delegate { };
        }

        public void Complete()
        {
            onComplete(this);
        }

        public void Finish()
        {
            onFinish(this);
        }
    }
}