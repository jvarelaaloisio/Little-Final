using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Events
{
    [CreateAssetMenu(fileName = "LevelDataContainer", menuName = "Lemu/LevelDataContainer", order = 0)]
    public class LevelDataContainer : ScriptableObject
    {
        [Tooltip("scenes to load immediately")]
        public int[] immediateLoadBuildIndexes;
        public int activeSceneIndex;
        [Tooltip("scenes that can be loaded after starting the game")]
        public LevelLoadBatch[] batchedLoads;

        public List<AsyncOperation> Load()
        {
            var ao = new List<AsyncOperation>();
            foreach (var index in immediateLoadBuildIndexes) ao.Add(SceneManager.LoadSceneAsync(index, LoadSceneMode.Additive));
            return ao;
        }

        //TODO: Make coroutine/Async op
        public void Unload()
        {
            foreach (var index in immediateLoadBuildIndexes)
                SceneManager.UnloadSceneAsync(index);
            foreach (var batchedLoad in batchedLoads)
                foreach (var index in batchedLoad.buildIndexes)
                    SceneManager.UnloadSceneAsync(index);
        }
    }
}