using System;
using Core.Attributes;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Menus.Events
{
    [Serializable]
    public class SerializableScene
    {
#if UNITY_EDITOR
        [SerializeField] private SceneAsset scene;
#endif
        [SerializeField, SerializeReadOnly] private int buildIndex;
        public int BuildIndex => buildIndex;

        public void Validate()
        {
#if UNITY_EDITOR
            if (scene)
                buildIndex = SceneUtility.GetBuildIndexByScenePath(AssetDatabase.GetAssetPath(scene));
#endif
        }

        public override string ToString()
        {
#if UNITY_EDITOR
            if (scene)
                return scene.ToString();
            return "null";
#endif
            return base.ToString();
        }
    }
}