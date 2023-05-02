#if(UNITY_EDITOR)
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MeshSaver
{
    public void SaveMesh(Mesh mesh, string path)
    {
        if (!AssetDatabase.IsValidFolder(path)) CreateFolder(path);
        AssetDatabase.CreateAsset(mesh, $"{path}/{mesh.name}{Random.Range(100000, 1000000)}.asset");
    }

    private void CreateFolder(string path)
    {
        string[] folders = path.Split('/');
        for (int folderIndex = 0; !AssetDatabase.IsValidFolder(path); folderIndex++)
            AssetDatabase.CreateFolder(GetPath(folders, folderIndex + 1), folders[folderIndex + 1]);
    }

    private string GetPath(string[] folders, int foldersCount)
    {
        string result = "";
        for (int i = 0; i < foldersCount; i++)
        {
            result += folders[i];
            if (i < foldersCount - 1) result += "/";
        }

        return result;
    }
}
#endif