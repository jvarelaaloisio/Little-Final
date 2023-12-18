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

        [Obsolete] private List<int> _buildIndexes = new();
        public override int Length => scenes.Count;

        [Obsolete] public List<int> BuildIndexes => _buildIndexes;

        public override void Validate()
        {
            scenes.ForEach(scene => scene.Validate());
            _buildIndexes = scenes.Where(SceneIsValid)
                                  .Select(scene => scene.BuildIndex)
                                  .ToList();

            bool SceneIsValid(SerializableScene scene)
                => scene.BuildIndex != -1;
        }

        public override IEnumerable<SceneAsyncOperation> GetLoadBatch()
            => scenes
               .Select(scene => scene.BuildIndex)
               .Select(i
                           => new SceneAsyncOperation(SceneUtility.GetScenePathByBuildIndex(i),
                                                      SceneManager.LoadSceneAsync(i, LoadSceneMode.Additive)));

        public override IEnumerable<SceneAsyncOperation> GetUnloadBatch()
            => scenes
               .Select(scene => scene.BuildIndex)
               .Where(i => SceneManager.GetSceneAt(i).isLoaded)
               .Select(i => new SceneAsyncOperation(SceneUtility.GetScenePathByBuildIndex(i),
                                                    SceneManager.UnloadSceneAsync(i)));
    }
}