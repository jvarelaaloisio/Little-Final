using System.Linq;
using System.Text;
using Core.Items;
using UnityEditor;
using UnityEngine;

public class InventoryDebuggerWindow : EditorWindow
{
    private const string WindowTitle = "Inventory Debugger";
    
    private Inventory inventory;

    [MenuItem("Game Design/Inventory Debugger")]
    public static void OpenWindow()
    {
        var w = GetWindow<InventoryDebuggerWindow>();
        w.titleContent.text = WindowTitle;
        w.Show();
    }
    
    private void OnGUI()
    {
        inventory = (Inventory)EditorGUILayout.ObjectField(inventory, typeof(Inventory), true);
        if (!inventory)
            return;
        var inventoryData = inventory.Items;
        // GUILayout.SelectionGrid(0, inventoryData.Select(kvp => $"{kvp.Key.name}\t{kvp.Value.Quantity}").ToArray(), 10);
        var dataStrings = inventoryData.Select(kvp => $"{kvp.Key.name}\t{kvp.Value.Quantity}");
        foreach (var dataString in dataStrings)
        {
            GUILayout.Label(dataString);
            
        }
    }
}
