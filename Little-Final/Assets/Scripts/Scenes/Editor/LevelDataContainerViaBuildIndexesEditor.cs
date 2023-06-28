using System;
using System.Collections.Generic;
using System.Linq;
using Menus.Events;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Scenes.Editor
{
    [CustomEditor(typeof(LevelDataContainerViaBuildIndexes))]
    public class LevelDataContainerViaBuildIndexesEditor : UnityEditor.Editor
    {
        private const int buttonWidth = 30;
        private const int LoadBatchMaxWidth = 200;
        private LevelDataContainerViaBuildIndexes _levelDataContainer;
        private List<SceneAsset> _immediateSceneAssets;
        private Dictionary<LevelLoadBatch, List<SceneAsset>> _sceneAssetsByLoadBatch = new();
        private LevelLoadBatchViaBuildIndexes _immediateLoadBatch;
        private GUIStyle _boldButtonStyle;
        private bool _isImmediateLoadUnfolded = false;
        private Dictionary<LevelLoadBatch, bool> _isSceneListUnfoldedByBatch = new();
        private SceneAsset _activeSceneAsset;

        private void OnEnable()
        {
            _levelDataContainer = (LevelDataContainerViaBuildIndexes)serializedObject.targetObject;
            _immediateLoadBatch = (LevelLoadBatchViaBuildIndexes)_levelDataContainer.ImmediateLoadBatch;
            CopyFromBatchToSceneAssetListBasedOnBuildSettings(in _immediateLoadBatch, out _immediateSceneAssets);
            ResetBatches();
            _activeSceneAsset =
                GetSceneAssetByBuildIndex(EditorBuildSettings.scenes, _levelDataContainer.activeSceneIndex);
        }

        private void ResetBatches()
        {
            foreach (var levelLoadBatch in _levelDataContainer.LevelBatches)
            {
                var batch = levelLoadBatch as LevelLoadBatchViaBuildIndexes;
                if (batch == null)
                {
                    Debug.LogError(
                        $"{name}: Batch couldn't be casted from {levelLoadBatch.GetType()} to {typeof(LevelLoadBatchViaBuildIndexes)}");
                }

                CopyFromBatchToSceneAssetListBasedOnBuildSettings(in batch, out var sceneAssets);
                if (!_sceneAssetsByLoadBatch.TryAdd(levelLoadBatch, sceneAssets))
                    _sceneAssetsByLoadBatch[levelLoadBatch] = sceneAssets;
                _isSceneListUnfoldedByBatch.TryAdd(levelLoadBatch, false);
            }
        }

        public override void OnInspectorGUI()
        {
            // base.OnInspectorGUI();
            _boldButtonStyle = new GUIStyle(GUI.skin.button)
            {
                fontStyle = FontStyle.Bold
            };
            
            _isImmediateLoadUnfolded = EditorGUILayout.BeginFoldoutHeaderGroup(_isImmediateLoadUnfolded, "Immediate Load Batch");
            if (_isImmediateLoadUnfolded)
            {
                DrawSceneAssetListOnGUI(ref _immediateSceneAssets,
                    _immediateLoadBatch,
                    _ => CopyFromBatchToSceneAssetListBasedOnBuildSettings(in _immediateLoadBatch, out _immediateSceneAssets),
                    _ => CopyFromBatchToSceneAssetListBasedOnBuildSettings(in _immediateLoadBatch, out _immediateSceneAssets));
            }
            EditorGUILayout.EndFoldoutHeaderGroup();

            for (var batchIndex = 0; batchIndex < _immediateSceneAssets.Count; batchIndex++)
            {
                var sceneAsset = _immediateSceneAssets[batchIndex];
                if (sceneAsset == null)
                    continue;
                for (var buildIndex = 0; buildIndex < EditorBuildSettings.scenes.Length; buildIndex++)
                {
                    var settingsScene = EditorBuildSettings.scenes[buildIndex];
                    if (settingsScene.path == AssetDatabase.GetAssetPath(sceneAsset))
                    {
                        _immediateLoadBatch.BuildIndexes[batchIndex] = buildIndex;
                    }
                }
            }

            #region Batched loads

            GUILayout.BeginVertical(EditorStyles.helpBox);
            var titleStyle = EditorStyles.label;
            titleStyle.fontStyle = FontStyle.Bold;
            var BatchedLoadsTitle = new GUIContent("Batched Loads");
            GUILayout.Label(BatchedLoadsTitle, titleStyle);
            GUILayout.BeginHorizontal();
            GUILayout.Space(20);
            var counter = 0;
            var loadBatchDictionary = new Dictionary<LevelLoadBatch, List<SceneAsset>>(_sceneAssetsByLoadBatch);
            foreach (var sceneAssetsByLoadBatch in loadBatchDictionary)
            {
                GUILayout.BeginVertical(EditorStyles.helpBox, GUILayout.MaxWidth(LoadBatchMaxWidth));
                GUILayout.BeginHorizontal();
                GUILayout.Space(20);
                _isSceneListUnfoldedByBatch[sceneAssetsByLoadBatch.Key]
                    = EditorGUILayout.BeginFoldoutHeaderGroup(
                        _isSceneListUnfoldedByBatch[sceneAssetsByLoadBatch.Key], counter.ToString());
                GUILayout.Space(12);
                GUILayout.EndHorizontal();
                if (_isSceneListUnfoldedByBatch[sceneAssetsByLoadBatch.Key])
                {
                    var sceneAssets = sceneAssetsByLoadBatch.Value;
                    var batch = sceneAssetsByLoadBatch.Key as LevelLoadBatchViaBuildIndexes;
                    DrawSceneAssetListOnGUI(ref sceneAssets,
                        batch,
                        _ =>
                        {
                            CopyFromBatchToSceneAssetListBasedOnBuildSettings(in batch, out var newValue);
                            _sceneAssetsByLoadBatch[sceneAssetsByLoadBatch.Key] = newValue;
                        },
                        _ =>
                        {
                            CopyFromBatchToSceneAssetListBasedOnBuildSettings(in batch, out var newValue);
                            _sceneAssetsByLoadBatch[sceneAssetsByLoadBatch.Key] = newValue;
                        });
                }

                #region Remove

                Event currentEvent = Event.current;
                if (currentEvent.type == EventType.MouseDown && currentEvent.button == 1)
                {
                    if (GUILayoutUtility.GetLastRect().Contains(currentEvent.mousePosition))
                    {
                        var backupValue = _levelDataContainer.batchedLoads[counter];
                        _levelDataContainer.batchedLoads.RemoveAt(counter);
                        _isSceneListUnfoldedByBatch.Remove(backupValue);
                        _sceneAssetsByLoadBatch.Remove(backupValue);
                        ResetBatches();
                        Repaint();
                    }
                }

                #endregion
                
                EditorGUILayout.EndFoldoutHeaderGroup();
                counter++;
                GUILayout.EndVertical();
                GUILayout.FlexibleSpace();
                if (counter % 2 == 0)
                {
                    GUILayout.EndHorizontal();
                    GUILayout.BeginHorizontal();
                    GUILayout.Space(20);
                }
            }

            GUILayout.EndHorizontal();
            
            #region + Button

            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            if (GUILayout.Button("+", _boldButtonStyle, GUILayout.Width(buttonWidth)))
            {
                var batch = new LevelLoadBatchViaBuildIndexes();
                _levelDataContainer.batchedLoads.Add(batch);
                ResetBatches();
                Repaint();
            }
            EditorGUILayout.EndHorizontal();

            #endregion
            
            GUILayout.EndVertical();

            #endregion

            _activeSceneAsset = EditorGUILayout.ObjectField("Active Scene",
                                                            _activeSceneAsset,
                                                            typeof(SceneAsset),
                                                            false)
                                                                as SceneAsset;
            if (_activeSceneAsset)
            {
                var scenePath = AssetDatabase.GetAssetPath(_activeSceneAsset);
                if (EditorBuildSettings.scenes.Any(scene => scene.path == scenePath))
                {
                    var sceneIndex = SceneUtility.GetBuildIndexByScenePath(scenePath);
                    _levelDataContainer.activeSceneIndex = sceneIndex;
                }
            }
        }

        /// <summary>
        /// Draws an editable list of scene assets in a GUI
        /// </summary>
        /// <param name="sceneAssets">editable list of scene assets</param>
        /// <param name="onRemoveIndex"></param>
        /// <param name="onAddIndex"></param>
        /// <param name="batch"></param>
        private void DrawSceneAssetListOnGUI(ref List<SceneAsset> sceneAssets, LevelLoadBatchViaBuildIndexes batch,
            Action<int> onRemoveIndex, Action<int> onAddIndex)
        {
            for (var i = 0; i < sceneAssets.Count; i++)
            {
                EditorGUILayout.BeginHorizontal();
                sceneAssets[i] = EditorGUILayout.ObjectField(sceneAssets[i], typeof(SceneAsset), false) as SceneAsset;

                #region - Button

                if (GUILayout.Button("-", _boldButtonStyle, GUILayout.Width(buttonWidth)))
                {
                    batch.BuildIndexes.RemoveAt(i);
                    onRemoveIndex(i);
                }

                #endregion

                EditorGUILayout.EndHorizontal();
            }

            #region + Button

            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            if (GUILayout.Button("+", _boldButtonStyle, GUILayout.Width(buttonWidth)))
            {
                batch.BuildIndexes.Add(0);
                onAddIndex(0);
            }
            EditorGUILayout.EndHorizontal();

            #endregion
        }

        /// <summary>
        /// Sets a list of assets to the correspondent scenes in build
        /// </summary>
        /// <param name="batch">batch of indexes to base on for the scenes to load</param>
        /// <param name="sceneAssets">The assets that will be populated with the build index scenes</param>
        private static void CopyFromBatchToSceneAssetListBasedOnBuildSettings(
            in LevelLoadBatchViaBuildIndexes batch,
            out List<SceneAsset> sceneAssets)
        {
            sceneAssets = new List<SceneAsset>();
            var scenesInBuild = EditorBuildSettings.scenes;
            foreach (var index in batch.BuildIndexes)
            {
                if (scenesInBuild.Length <= index)
                    continue;
                var scene = GetSceneAssetByBuildIndex(scenesInBuild, index);
                sceneAssets.Add(scene);
            }
        }

        /// <summary>
        /// Loads the asset path for the build index of a scene
        /// </summary>
        /// <param name="scenesInBuild"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        private static SceneAsset GetSceneAssetByBuildIndex(IReadOnlyList<EditorBuildSettingsScene> scenesInBuild, int index)
        {
            return AssetDatabase.LoadAssetAtPath<SceneAsset>(SceneUtility.GetScenePathByBuildIndex(index));
        }
    }
}