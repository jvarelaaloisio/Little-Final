using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;

namespace Menus.Events
{
    [Serializable]
    [Obsolete]
    public class LevelLoadBatchViaScenes : LevelLoadBatch
    {
        [SerializeField]
        private Scene[] scenes;

        public override int Length => scenes.Length;

        public override IEnumerable<SceneAsyncOperation> GetLoadBatch()
            => scenes
                .Select(scene => new SceneAsyncOperation(scene.name,
                                                         SceneManager.LoadSceneAsync(scene.buildIndex,
                                                                                     LoadSceneMode.Additive)));

        public override IEnumerable<SceneAsyncOperation> GetUnloadBatch()
            => scenes
                .Select(scene => new SceneAsyncOperation(scene.name, SceneManager.UnloadSceneAsync(scene)));
    }
}