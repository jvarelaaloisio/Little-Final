using System;
using Core.Helpers;
using Core.Items;
using UnityEditor;
using UnityEngine;

public class InventoryDebuggerWindow : EditorWindow
{
    private const string WindowTitle = "Inventory Debugger";

    private readonly SelectionField<Inventory> _inventoryField = new SceneSelectionField<Inventory>();
    private readonly SelectionField<IdContainer> _idField = new ScriptableObjectSelectionField<IdContainer>();

    private readonly GUIStyleDecorator _warningStyle = new(style =>
    {
        style.normal.textColor = Color.yellow;
        style.hover.textColor = Color.yellow;
    });

    private readonly GUIStyleDecorator _centeredStyle = new(style => style.alignment = TextAnchor.MiddleCenter);

    private int _unitsToAddToNewItem;

    [MenuItem("Game Design/Inventory Debugger")]
    public static void OpenWindow()
    {
        var w = GetWindow<InventoryDebuggerWindow>();
        w.titleContent.text = WindowTitle;
        w.Show();
    }

    private void OnEnable()
    {
        _inventoryField.OnEnable();
        _idField.OnEnable();
        if (EditorSelectionTools.TryGetObjectFromTarget(out Inventory inventory))
        {
            _inventoryField.SetValueAndUpdateSelectionIndex(inventory);
        }
    }

    private void OnGUI()
    {

        _inventoryField.OnGUI();
        if (!_inventoryField.Get)
            return;

        var currentItems = _inventoryField.Get.Items;
        if (currentItems.Count < 1)
        {
            _warningStyle.InitializeIfNull(GUI.skin.label);
            GUILayout.Label($"{_inventoryField.Get.name} doesn't have any items", _warningStyle);
        }

        foreach (var kvp in currentItems)
        {
            GUILayout.BeginHorizontal();
            // -->
            GUILayout.Label($"{kvp.Key.name}", GUILayout.Width(200));
            _inventoryField.Get.TryGetItem(kvp.Key, out var item);
            EditorGUI.BeginDisabledGroup(item == null);
            // ○
            if (GUILayout.Button("-"))
            {
                item.RemoveUnit(new QuantifiedItem(1));

            }

            if (GUILayout.Button("-10"))
            {
                item.RemoveUnit(new QuantifiedItem(10));
            }

            _centeredStyle.InitializeIfNull(GUI.skin.label);

            GUILayout.Label($"{kvp.Value.Quantity}", _centeredStyle, GUILayout.Width(50));

            if (GUILayout.Button("+"))
            {
                item.AddUnit(new QuantifiedItem(1));
            }

            if (GUILayout.Button("+10"))
            {
                item.AddUnit(new QuantifiedItem(10));
            }
            // ☼
            EditorGUI.EndDisabledGroup();

            // <--
            GUILayout.EndHorizontal();
        }

        GUILayout.Space(5);
        _idField.OnGUI();
        GUILayout.BeginHorizontal();
        // -->
        _unitsToAddToNewItem = EditorGUILayout.IntField("Qty", 1);
        if (_idField.Get && GUILayout.Button("+"))
        {
            if (_inventoryField.Get.TryGetItem(_idField.Get.Get, out var item))
                item.AddUnit(new QuantifiedItem(_unitsToAddToNewItem));
            else if (!_inventoryField.Get.TryAddItem(_idField.Get.Get, new QuantifiedItem(_unitsToAddToNewItem)))
                Debug.LogError($"Couldn't get or add item [{item}] to inventory [{_inventoryField.Get.name}]");
        }

        // <--
        GUILayout.EndHorizontal();
    }
}