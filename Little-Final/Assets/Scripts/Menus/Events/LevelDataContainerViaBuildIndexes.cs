using System.Collections.Generic;
using UnityEngine;

namespace Menus.Events
{
    [CreateAssetMenu(fileName = "LevelDataContainerViaIndexes",
                        menuName = "Levels/Level Data Container via Build Indexes", order = 0)]
    public class LevelDataContainerViaBuildIndexes : LevelDataContainer
    {
        [Tooltip("scenes to load immediately")] [SerializeField]
        private LevelLoadBatchViaBuildIndexes immediateLoadBatch;

        [Space(25f)]
        [Tooltip("scenes that can be loaded after starting the game")]
        public List<LevelLoadBatchViaBuildIndexes> batchedLoads;

        public override LevelLoadBatch ImmediateLoadBatch => immediateLoadBatch;
        public override IEnumerable<LevelLoadBatch> LevelBatches => batchedLoads;
    }
}