using System;
using System.Linq;
using UnityEditor;
using UnityEngine;

/// <summary>
/// Editor class that draws a selection field and handles the references needed for it to work.
/// </summary>
/// <typeparam name="T">The object type that will be used by the handler</typeparam>
public abstract class SelectionField<T> where T : UnityEngine.Object
{
    private const string RefreshText = "◌";
    private const int RefreshButtonWidth = 25;
    private const string SelectText = "→";
    private const int SelectButtonWidth = 25;
    public T Get { get; protected set; }
    public T[] AvailableOptions { get; protected set; } = Array.Empty<T>();

    private int _selectionIndex = 0;
    private readonly GUIContent _refreshButton;
    private readonly GUIContent _selectButton;

    /// <summary>
    /// Basic Constructor
    /// </summary>
    /// <param name="refreshButtonGui">Override for the Refresh button</param>
    /// <param name="selectButtonGui">Override for the Select button</param>
    public SelectionField(GUIContent refreshButtonGui = null, GUIContent selectButtonGui = null)
    {
        _refreshButton = refreshButtonGui??new GUIContent(RefreshText);
        _selectButton = selectButtonGui??new GUIContent(SelectText);
    }

    /// <summary>
    /// Called when selection value changed.
    /// Parameters are [old] and [new]
    /// </summary>
    public event Action<T, T> OnValueChanged = delegate { };
    
    /// <summary>
    /// Called when updating the option list.
    /// Parameters are [old] and [new]
    /// </summary>
    public event Action<T[], T[]> OnUpdatedOptionsList = delegate { };

    /// <summary>
    /// Runs needed logic for correct behaviour. Call this from OnEnable()
    /// </summary>
    public void OnEnable()
    {
        UpdateOptionsList();
    }
    
    /// <summary>
    /// Draws the selection field. Call this from OnGUI()
    /// </summary>
    public void OnGUI()
    {
        GUILayout.BeginHorizontal();
        // -->
        var tempValue = EditorGUILayout.ObjectField(Get, typeof(T), true) as T;
        SetValueAndUpdateSelectionIndex(tempValue);

        if (GUILayout.Button(_refreshButton, GUILayout.Width(RefreshButtonWidth)))
            UpdateOptionsList();

        var indexTempValue = EditorGUILayout.Popup(_selectionIndex,
                                                            AvailableOptions
                                                                .Where(obj => obj != null)
                                                                .Select(obj => obj.name)
                                                                .ToArray());
        if (_selectionIndex != indexTempValue)
        {
            Get = AvailableOptions[indexTempValue];
            _selectionIndex = indexTempValue;
        }

        if (GUILayout.Button(_selectButton, GUILayout.Width(SelectButtonWidth)))
        {
            Selection.SetActiveObjectWithContext(Get, Get);
        }
        // <--
        GUILayout.EndHorizontal();
    }

    /// <summary>
    /// Updates dropdown list by finding every object of type T.
    /// <p>Raises <see cref="OnUpdatedOptionsList"/></p>
    /// </summary>
    public abstract void UpdateOptionsList();

    /// <summary>
    /// Sets the value reference and updates the selection index.
    /// <p>Raises <see cref="OnValueChanged"/></p>
    /// </summary>
    public void SetValueAndUpdateSelectionIndex(T newSelection)
    {
        if (Get != newSelection)
        {
            EditorSelectionTools.TryUpdateSelectionIndex(AvailableOptions, newSelection, ref _selectionIndex);
            OnValueChanged(Get, newSelection);
        }

        Get = newSelection;
    }

    public static implicit operator T(SelectionField<T> original)
    {
        return original.Get;
    }
    
    protected void SetOptionsList(T[] newValue)
    {
        OnUpdatedOptionsList(AvailableOptions, newValue);
        AvailableOptions = newValue;
        EditorSelectionTools.TryUpdateSelectionIndex(AvailableOptions, Get, ref _selectionIndex);
    }
}