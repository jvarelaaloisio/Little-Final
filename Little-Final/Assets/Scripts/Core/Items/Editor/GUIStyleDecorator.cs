using System;
using UnityEngine;

public class GUIStyleDecorator
{
    private GUIStyle _baseStyle;
    private readonly Action<GUIStyle> _applyStyleChanges;
    public GUIStyle Value { get; private set; }

    public GUIStyleDecorator(Action<GUIStyle> applyStyleChanges = null)
    {
        _applyStyleChanges = applyStyleChanges;
    }

    public void InitializeIfNull(GUIStyle baseStyle)
    {
        if (Value != null)
            return;
        _baseStyle = baseStyle;
        Value = new GUIStyle(_baseStyle);
        _applyStyleChanges?.Invoke(Value);
    }

    public static implicit operator GUIStyle(GUIStyleDecorator baseDecorator)
    {
        if (baseDecorator.Value == null)
            Debug.LogError($"{nameof(GetType)} is not initialized!!");
        return baseDecorator.Value;
    }
}