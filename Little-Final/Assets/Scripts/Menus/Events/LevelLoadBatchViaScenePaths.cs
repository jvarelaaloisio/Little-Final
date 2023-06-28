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

        public override IEnumerable<AsyncOperation> LoadBatch()
            => paths
                .Select(path
                    => SceneManager.LoadSceneAsync((string)path, LoadSceneMode.Additive));

        public override IEnumerable<AsyncOperation> UnloadBatch()
            => paths
                .Select(SceneManager.UnloadSceneAsync);
    }
}