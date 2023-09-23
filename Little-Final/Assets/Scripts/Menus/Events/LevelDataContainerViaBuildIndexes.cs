using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Menus.Events
{
    [CreateAssetMenu(fileName = "LevelDataContainerViaIndexes", menuName = "Levels/Level Data Container via Build Indexes", order = 0)]
    public class LevelDataContainerViaBuildIndexes : LevelDataContainer
    {
        [Obsolete]
        public int[] immediateLoadBuildIndexes;

        [Tooltip("scenes to load immediately")]
        [SerializeField] private LevelLoadBatchViaBuildIndexes immediateLoadBatch;
        
        public int activeSceneIndex;
        [Tooltip("scenes that can be loaded after starting the game")]
        public List<LevelLoadBatchViaBuildIndexes> batchedLoads;
        
        public override LevelLoadBatch ImmediateLoadBatch => immediateLoadBatch;
        public override IEnumerable<LevelLoadBatch> LevelBatches => batchedLoads;

        public List<AsyncOperation> Load()
        {
            var ao = new List<AsyncOperation>();
            foreach (var index in immediateLoadBuildIndexes) ao.Add(SceneManager.LoadSceneAsync(index, LoadSceneMode.Additive));
            return ao;
        }

        //TODO: Make coroutine/Async op
        //BUG: Unloading when the batched loads haven't still been loaded generates exceptions
        public override void Unload()
        {
            foreach (var unloadOperation in immediateLoadBatch.UnloadBatch())
            {
                Debug.Log($"Unloaded {unloadOperation}");
            }
            foreach (var batchedLoad in batchedLoads)
                foreach (var unloadOperation in batchedLoad.UnloadBatch())
                {
                    //TODO: should yield return
                    Debug.Log($"Unloaded {unloadOperation}");
                }
        }

        public override IEnumerable<AsyncOperation> LoadImmediateScenes() => immediateLoadBatch.LoadBatch();
    }
}