using System;
using System.Collections.Generic;

namespace Menus.Events
{
    public abstract class LevelLoadBatch
    {
        public abstract int Length { get; }
        public virtual void Validate() { }

        public abstract IEnumerable<SceneAsyncOperation> GetLoadBatch();

        /// <summary>
        /// Returns all async operations for the unload of the level.
        /// </summary>
        /// <returns>A collection of asyncOperations, one for each scene. And, alongside them, a string with the name of the scene.</returns>
        public abstract IEnumerable<SceneAsyncOperation> GetUnloadBatch();
    }
}