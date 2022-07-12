using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Events
{
    [CreateAssetMenu(fileName = "LevelDataContainer", menuName = "Lemu/LevelDataContainer", order = 0)]
    public class LevelDataContainer : ScriptableObject
    {
        public int[] buildIndexes;
        public int activeSceneIndex;

        public List<AsyncOperation> Load()
        {
            var ao = new List<AsyncOperation>();
            foreach (var index in buildIndexes) ao.Add(SceneManager.LoadSceneAsync(index, LoadSceneMode.Additive));
            return ao;
        }

        public void Unload()
        {
            foreach (var index in buildIndexes) SceneManager.UnloadSceneAsync(index);
        }
    }
}