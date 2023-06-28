using Menus.Events;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

[CustomEditor(typeof(LevelLoadBatchViaBuildIndexes))]
public class LevelLoadBatchViaBuildIndexesEditor : Editor
{
    private SerializedProperty buildIndexesProperty;
    private SerializedProperty sceneAssetsProperty;

    private void OnEnable()
    {
        buildIndexesProperty = serializedObject.FindProperty("buildIndexes");
        sceneAssetsProperty = serializedObject.FindProperty("sceneAssets");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUILayout.PropertyField(sceneAssetsProperty, true);

        // Update buildIndexes based on sceneAssets
        if (GUILayout.Button("Update Build Indexes"))
        {
            UpdateBuildIndexes();
        }

        EditorGUILayout.PropertyField(buildIndexesProperty, true);

        serializedObject.ApplyModifiedProperties();
    }

    private void UpdateBuildIndexes()
    {
        // LevelLoadBatchViaBuildIndexes levelLoadBatch = target as LevelLoadBatchViaBuildIndexes;
        //
        // levelLoadBatch.BuildIndexes.Clear();
        //
        // for (int i = 0; i < sceneAssetsProperty.arraySize; i++)
        // {
        //     SceneAsset sceneAsset = (SceneAsset)sceneAssetsProperty.GetArrayElementAtIndex(i).objectReferenceValue;
        //     string scenePath = AssetDatabase.GetAssetPath(sceneAsset);
        //     int buildIndex = SceneUtility.GetBuildIndexByScenePath(scenePath);
        //     levelLoadBatch.BuildIndexes.Add(buildIndex);
        // }
        //
        // EditorUtility.SetDirty(target);
    }
}