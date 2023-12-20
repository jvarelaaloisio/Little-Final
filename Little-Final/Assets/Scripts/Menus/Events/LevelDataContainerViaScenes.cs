using System;
using System.Collections.Generic;
using UnityEngine;

namespace Menus.Events
{
    [Obsolete]
    [CreateAssetMenu(fileName = "LevelDataContainerViaScenes", menuName = "Levels/Level Data Container via Scenes", order = 0)]
    public class LevelDataContainerViaScenes : LevelDataContainer
    {
        [Tooltip("scenes to load immediately")]
        [SerializeField] private LevelLoadBatchViaScenes immediateLoadBatch;
        
        public int activeSceneIndex;
        [Tooltip("scenes that can be loaded after starting the game")]
        public LevelLoadBatchViaScenes[] batches;
        
        public override LevelLoadBatch ImmediateLoadBatch => immediateLoadBatch;
        public override IEnumerable<LevelLoadBatch> LevelBatches => batches;
    }
}