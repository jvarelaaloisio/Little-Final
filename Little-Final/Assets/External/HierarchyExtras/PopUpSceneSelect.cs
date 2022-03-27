using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace External.HierarchyExtras
{
    public class PopUpSceneSelect : EditorWindow
    {
        private static EditorWindow _window;
        private GameObject[] _gameObjects;
        private bool _reParentGo = true;
        private string _newSceneName;
        private string _scenesPath = "Scenes/";

        private GUIStyle guiLabel = new GUIStyle() {fontStyle = FontStyle.Bold};
        
        [MenuItem("GameObject/Sort Tools/Move To Scene", false, 0)]
        public static void ShowPopUpSceneSelect()
        {
            _window = GetWindow(typeof(PopUpSceneSelect));
            _window.maxSize = new Vector2(301,301);
            _window.minSize = new Vector2(300,300);
            _window.CenterOnMainWindow();
        }

        private void OnEnable()
        {
            _gameObjects = Selection.gameObjects;
        }

        private void OnGUI()
        {
            var sceneCount = SceneManager.sceneCount;
            
            _reParentGo = EditorGUILayout.Toggle("Re-parent no root GameObject  ", _reParentGo);

            if (GUILayout.Button("Manual re parent") && Selection.gameObjects.Length == 1)
            {
                var go = Selection.activeGameObject;
                go.transform.parent = null;
            }   
            
            EditorGUILayout.Space();
            
            EditorGUILayout.LabelField("Loaded Scenes");
            for (var i = 0; i < sceneCount; i++)
            {
                var scene = SceneManager.GetSceneAt(i);
                
                if (GUILayout.Button(scene.name))
                {
                    try
                    {
                        var errorGo = new List<GameObject>();
                        foreach (var go in _gameObjects)
                        {
                            if (PrefabUtility.GetPrefabAssetType(go) != PrefabAssetType.NotAPrefab
                                && go.transform.parent)
                            {
                                errorGo.Add(go);
                                continue;
                            }
                            
                            if (_reParentGo && go.transform.parent)
                            {
                                go.transform.SetParent(null);
                            }
                            
                            if (go.transform.parent)
                            {
                                Debug.LogError(
                                    "Error moving go: gameObjet is not a root in a scene, " +
                                    "check Re-parent toggle to force it", go);
                                continue;
                            }
                            
                            if (go.scene.buildIndex == scene.buildIndex)
                            {
                                continue;   
                            }
                            
                            SceneManager.MoveGameObjectToScene(go, scene);
                        }
                        
                        errorGo.ForEach(e => 
                            Debug.LogError("Error moving go: gameObject is a prefab, make prefab a root in scene" + e.name, e));
                    }
                    catch (Exception e)
                    {
                        //Debug.Log(e.Message);
                    }
                    finally
                    {
                        _window.Close();
                        EditorSceneManager.SaveScene(scene);
                    }
                }
            }
            
            EditorGUILayout.Space();
            
            if (GUILayout.Button("Cancel"))
            {
                _window.Close();
            }
        }
        
    }
}
