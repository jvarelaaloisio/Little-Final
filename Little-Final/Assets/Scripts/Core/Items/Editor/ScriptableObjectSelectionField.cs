using System.Linq;
using UnityEditor;
using UnityEngine;

public class ScriptableObjectSelectionField<T> : SelectionField<T> where T : ScriptableObject
{
    public override void UpdateOptionsList()
    {
        var Tname = typeof(T).Name;
        var guids = AssetDatabase.FindAssets($"t:{Tname}");
        var assets = guids.Select(guid => AssetDatabase.LoadAssetAtPath<T>(AssetDatabase.GUIDToAssetPath(guid)))
            .ToArray();

        SetOptionsList(assets);
    }
}