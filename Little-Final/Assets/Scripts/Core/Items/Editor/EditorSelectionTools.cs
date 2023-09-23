using System;
using UnityEditor;

public static class EditorSelectionTools
{
    public static bool TryUpdateSelectionIndex<T>(T[] options,
        T current,
        ref int selectedIndex)
    {
        var inventoryIndex = Array.IndexOf(options, current);
        if (inventoryIndex == -1)
            return false;
        selectedIndex = inventoryIndex;
        return true;
    }
    
    public static bool TryGetObjectFromTarget<T>(out T obj) where T : UnityEngine.Object
    {
        T tempValue = default;
        if(Selection.activeGameObject
           && Selection.activeGameObject.TryGetComponent(out tempValue))
            obj = tempValue;
        else
            obj = default;
        return tempValue != null;
    }
}