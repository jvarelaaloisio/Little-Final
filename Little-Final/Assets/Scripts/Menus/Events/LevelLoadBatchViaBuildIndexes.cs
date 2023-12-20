using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Menus.Events
{
    [Serializable]
    public class LevelLoadBatchViaBuildIndexes : LevelLoadBatch
    {
        [SerializeField] private List<SerializableScene> scenes = new();

        public override int Length => scenes.Count;

        //TODO: Remove
        [Obsolete] public List<int> BuildIndexes => scenes.Select(scene => scene.BuildIndex).ToList();

        public override void Validate() => scenes.ForEach(scene => scene.Validate());

        public override IEnumerable<SceneAsyncOperation> GetLoadBatch()
            => scenes
               .Select(scene => scene.BuildIndex)
               .Select(i
                           => new SceneAsyncOperation(SceneUtility.GetScenePathByBuildIndex(i),
                                                      SceneManager.LoadSceneAsync(i, LoadSceneMode.Additive)));

        public override IEnumerable<SceneAsyncOperation> GetUnloadBatch()
            => scenes
               .Select(scene => scene.BuildIndex)
               .Where(i => SceneManager.GetSceneByBuildIndex(i).isLoaded)
               .Select(i => new SceneAsyncOperation(SceneUtility.GetScenePathByBuildIndex(i),
                                                    SceneManager.UnloadSceneAsync(i)));
    }
}