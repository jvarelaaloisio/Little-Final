using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace Environment.MaterialPropertyBlockHelper.Editor
{
    public class MaterialPropertyBlockWindow : EditorWindow
    {
        [MenuItem("Tools/Material Property Block Window")]
        public static void ShowWindow()
        {
            GetWindow<MaterialPropertyBlockWindow>("Material Property Block Window");
        }

        private void OnGUI()
        {
            GUILayout.Label("Init Material Property Blocks", EditorStyles.boldLabel);

            if (GUILayout.Button("Apply in opened scenes"))
            {
                InitAllMaterialPropertyBlocks();
            }
            
            if (GUILayout.Button("Apply in selection"))
            {
                InitAllMaterialPropertyBlocksInPrefab();
            }
        }

        private void InitAllMaterialPropertyBlocks()
        {
            // Obtiene el número de escenas raíz cargadas en el editor
            int sceneCount = EditorSceneManager.loadedRootSceneCount;

            // Itera sobre cada escena raíz cargada
            for (int i = 0; i < sceneCount; i++)
            {
                var scene = EditorSceneManager.GetSceneAt(i);

                GameObject[] rootObjects = scene.GetRootGameObjects();

                foreach (GameObject rootObject in rootObjects)
                {
                    MaterialPropertyBlockManager[] managers = rootObject.GetComponentsInChildren<MaterialPropertyBlockManager>();

                    foreach (MaterialPropertyBlockManager manager in managers)
                    {
                        manager.InitComponentAndSetProperties();
                    }
                }
            }

            Debug.Log("Initialized all Material Property Blocks in all loaded root scenes.");
        }

        private void InitAllMaterialPropertyBlocksInPrefab()
        {
            // Obtiene el prefab actualmente seleccionado en el editor
            GameObject prefabRoot = Selection.activeGameObject;

            if (prefabRoot != null)
            {
                MaterialPropertyBlockManager[] managers =
                    prefabRoot.GetComponentsInChildren<MaterialPropertyBlockManager>();

                foreach (MaterialPropertyBlockManager manager in managers)
                {
                    manager.InitComponentAndSetProperties();
                }

                Debug.Log("Initialized all Material Property Blocks in current prefab.");
            }
            else
            {
                Debug.LogWarning("No prefab is currently selected.");
            }
        }
    }
}