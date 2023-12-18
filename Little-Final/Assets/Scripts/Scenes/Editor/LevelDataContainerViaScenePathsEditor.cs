using System.Collections.Generic;
using Menus.Events;
using UnityEditor;

namespace Scenes.Editor
{
    // [CustomEditor(typeof(LevelDataContainerViaScenePaths))]
    public class LevelDataContainerViaScenePathsEditor : UnityEditor.Editor
    {
        private LevelDataContainerViaScenePaths _levelDataContainer;
        private readonly List<SceneAsset> _sceneAssets = new List<SceneAsset>();
        private LevelLoadBatchViaScenePaths _immediateLoadBatch;

        private void OnEnable()
        {
            _levelDataContainer = (LevelDataContainerViaScenePaths) serializedObject.targetObject;
            _immediateLoadBatch = (LevelLoadBatchViaScenePaths)_levelDataContainer.ImmediateLoadBatch;
            foreach (var path in _immediateLoadBatch.Paths)
            {
                var scene = AssetDatabase.LoadAssetAtPath<SceneAsset>(
                    path);
                _sceneAssets.Add(scene);
            }
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            for (var i = 0; i < _sceneAssets.Count; i++)
            {
                _sceneAssets[i] = (SceneAsset)EditorGUILayout.ObjectField(_sceneAssets[i], typeof(SceneAsset), false);
            }

            for (var i = 0; i < _sceneAssets.Count; i++)
            {
                var sceneAsset = _sceneAssets[i];
                if(sceneAsset == null)
                    continue;
                _immediateLoadBatch.Paths[i] = AssetDatabase.GetAssetPath(sceneAsset);
            }
        }
    }
}
