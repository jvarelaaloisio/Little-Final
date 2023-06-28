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

        public override IEnumerable<AsyncOperation> LoadBatch()
            => scenes
                .Select(scene
                    => SceneManager.LoadSceneAsync((int)scene.buildIndex, LoadSceneMode.Additive));

        public override IEnumerable<AsyncOperation> UnloadBatch()
            => scenes
                .Select(SceneManager.UnloadSceneAsync);
    }
}