using UnityEngine;

namespace Menus.Events
{
    /// <summary>
    /// Container for a scene operation with all needed data
    /// </summary>
    public readonly struct SceneAsyncOperation
    {
        public readonly string Name;
        public readonly AsyncOperation AsyncOperation;

        public SceneAsyncOperation(string name, AsyncOperation asyncOperation)
        {
            Name = name;
            AsyncOperation = asyncOperation;
        }
    }
}