using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(MeshMerger))]
public class MeshMergerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        MeshMerger meshMerger = (MeshMerger)target;
        if (GUILayout.Button("Merge")) meshMerger.Merge();
    }
}
