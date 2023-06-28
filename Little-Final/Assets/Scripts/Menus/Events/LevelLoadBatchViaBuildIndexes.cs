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
        [SerializeField]
        private List<int> buildIndexes = new();

        public override int Length => buildIndexes.Count;

        public List<int> BuildIndexes => buildIndexes;
        
        public override IEnumerable<AsyncOperation> LoadBatch()
            => buildIndexes
                .Select(buildIndex
                    => SceneManager.LoadSceneAsync(buildIndex, LoadSceneMode.Additive));

        public override IEnumerable<AsyncOperation> UnloadBatch()
            => buildIndexes
                .Select(SceneManager.UnloadSceneAsync);
    }
}