using System;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Menus.Events
{
    /// <summary>
    /// Container for a scene operation with all needed data
    /// </summary>
    public readonly struct SceneAsyncOperation : IEquatable<SceneAsyncOperation>
    {
        public readonly Scene Scene;
        public readonly string Path;
        public readonly AsyncOperation AsyncOperation;

        public SceneAsyncOperation(string path, AsyncOperation asyncOperation)
        {
            Scene = SceneManager.GetSceneByPath(path);
            Path = path;
            AsyncOperation = asyncOperation;
        }

        public SceneAsyncOperation(Scene scene, AsyncOperation asyncOperation)
        {
            Scene = scene;
            Path = scene.path;
            AsyncOperation = asyncOperation;
        }

        /// <inheritdoc />
        public bool Equals(SceneAsyncOperation other)
            => Scene.Equals(other.Scene) && Equals(AsyncOperation, other.AsyncOperation);

        /// <inheritdoc />
        public override bool Equals(object obj)
            => obj is SceneAsyncOperation other && Equals(other);

        /// <inheritdoc />
        public override int GetHashCode()
            => HashCode.Combine(Scene, AsyncOperation);
    }
}