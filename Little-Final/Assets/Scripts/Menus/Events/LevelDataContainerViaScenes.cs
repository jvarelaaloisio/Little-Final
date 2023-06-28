using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;

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

        //TODO: Make coroutine/Async op
        //BUG: Unloading when the batched loads haven't still been loaded generates exceptions
        public override void Unload()
        {
            immediateLoadBatch.UnloadBatch();
            foreach (var batchedLoad in batches)
            foreach (var unloadOperation in batchedLoad.UnloadBatch())
            {
                //TODO: should yield return
                Debug.Log($"Unloaded {unloadOperation}");
            }
        }

        public override IEnumerable<AsyncOperation> LoadImmediateScenes() => immediateLoadBatch.LoadBatch();
    }
}