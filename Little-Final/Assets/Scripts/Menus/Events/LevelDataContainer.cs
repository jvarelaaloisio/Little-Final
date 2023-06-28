using System;
using System.Collections.Generic;
using UnityEngine;

namespace Menus.Events
{
    [Serializable]
    public abstract class LevelDataContainer : ScriptableObject
    {
        public abstract LevelLoadBatch ImmediateLoadBatch { get; }

        public abstract IEnumerable<LevelLoadBatch> LevelBatches { get; }

        public abstract void Unload();
        public abstract IEnumerable<AsyncOperation> LoadImmediateScenes();
    }
}