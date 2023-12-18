using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

namespace Menus.Events
{
    [CreateAssetMenu(fileName = "LevelDataContainerViaScenePaths", menuName = "Levels/Level Data Container via Scene Paths", order = 0)]
    public class LevelDataContainerViaScenePaths : LevelDataContainer
    {
        [Tooltip("scenes to load immediately")]
        [SerializeField]
        protected LevelLoadBatchViaScenePaths immediateLoadBatch;
        
        public int activeSceneIndex;
        [Tooltip("scenes that can be loaded after starting the game")]
        public LevelLoadBatchViaScenePaths[] batches;
        
        public override LevelLoadBatch ImmediateLoadBatch => immediateLoadBatch;
        public override IEnumerable<LevelLoadBatch> LevelBatches => batches;
        
        [ContextMenu("show type")]
        public void SHowType()
        {
            Debug.Log(ImmediateLoadBatch.GetType());
        }

        [ContextMenu("show derived type")]
        public void SHowDereivedType()
        {
            Debug.Log(immediateLoadBatch.GetType());
        }
    }
}