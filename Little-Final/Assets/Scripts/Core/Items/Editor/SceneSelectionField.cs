using UnityEngine;

public class SceneSelectionField<T> : SelectionField<T> where T : Object
{
    public override void UpdateOptionsList()
    {
        var newOptions = Object.FindObjectsOfType<T>(false);
        SetOptionsList(newOptions);
    }
}