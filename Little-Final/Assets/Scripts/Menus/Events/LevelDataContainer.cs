using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Menus.Events
{
    [Serializable]
    public abstract class LevelDataContainer : ScriptableObject
    {
        [field: Tooltip("Scene set as active. Must be previously loaded or be loaded in the immediate load batch")]
        [field: SerializeField]
        public SerializableScene ActiveScene { get; protected set; }

        public abstract LevelLoadBatch ImmediateLoadBatch { get; }

        public abstract IEnumerable<LevelLoadBatch> LevelBatches { get; }

        [NonSerialized]
        public List<string> RuntimeLoadedScenes = new();
        private void OnValidate()
        {
            ImmediateLoadBatch.Validate();
            foreach (var levelBatch in LevelBatches)
                levelBatch.Validate();
            ActiveScene.Validate();
        }

        /// <summary>
        /// Use to retrieve the List of Scenes to unload this level
        /// </summary>
        /// <returns>An enumerable of all the scenes to unload</returns>
        public virtual IEnumerable<SceneAsyncOperation> GetUnloadScenes()
        {
            return ImmediateLoadBatch.GetUnloadBatch()
                                     .Concat(LevelBatches.SelectMany(batchedLoad => batchedLoad.GetUnloadBatch()));
        }

        public virtual IEnumerable<SceneAsyncOperation> GetImmediateScenes()
            => ImmediateLoadBatch.GetLoadBatch();

        public virtual int GetTotalQuantityOfScenes()
        {
            return ImmediateLoadBatch.Length + LevelBatches
                                               .Select(batch => batch.Length)
                                               .DefaultIfEmpty(0)
                                               .Aggregate((total, current) => total + current);
        }
    }
}