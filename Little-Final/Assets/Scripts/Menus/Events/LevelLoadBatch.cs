using System;
using System.Collections.Generic;
using UnityEngine;

namespace Menus.Events
{
    public abstract class LevelLoadBatch
    {
        public abstract int Length { get; }
        public abstract IEnumerable<AsyncOperation> LoadBatch();
        public abstract IEnumerable<AsyncOperation> UnloadBatch();
    }
}