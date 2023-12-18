using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Menus.Events
{
    [Serializable]
    public class LevelLoadBatchViaScenePaths : LevelLoadBatch
    {
        [SerializeField]
        private string[] paths;

        public override int Length => paths.Length;

        public string[] Paths
        {
            get => paths;
            set => paths = value;
        }

        public override IEnumerable<SceneAsyncOperation> GetLoadBatch()
            => paths
                .Select(path
                    => new SceneAsyncOperation(path, SceneManager.LoadSceneAsync(path, LoadSceneMode.Additive)));

        public override IEnumerable<SceneAsyncOperation> GetUnloadBatch()
            => paths
                .Select(path => new SceneAsyncOperation(path, SceneManager.UnloadSceneAsync(path)));
    }
}