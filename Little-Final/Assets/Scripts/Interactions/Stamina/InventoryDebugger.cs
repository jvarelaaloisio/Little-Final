using System;
using Core.Helpers;
using Core.Items;
using UnityEngine;

public class InventoryDebugger : MonoBehaviour
{
    private const string AddItemUnitsToInventory = "Add item units to inventory";
    [SerializeField] private Inventory inventory;
    [SerializeField] private Id itemId;
    [SerializeField] private int unitsToAdd;

    private void OnValidate()
    {
        inventory ??= GetComponent<Inventory>();
    }

    private void Start()
    {
        if (inventory)
        {
            inventory.onItemAdded += HandleItemAdded;
        }
    }

    private void HandleItemAdded(Id itemId, Item item)
    {
        Debug.Log($"{name}: Item added ({item})");
        item.onQuantityChanged += LogItemQtyChanged;
    }

    private void LogItemQtyChanged(int from, int to)
    {
        Debug.Log($"{name}: Item quantity changed from {from} to {to}");
    }

    [ContextMenu(AddItemUnitsToInventory, true)]
    public bool AddUnitsToQuantifiedItemById_Validate()
    {
        return inventory;
    }
    
    [ContextMenu(AddItemUnitsToInventory, false)]
    public void AddUnitsToQuantifiedItemById()
    {
        if (inventory.TryGetItem(itemId, out Item item))
            (item as QuantifiedItem)?.AddUnits(unitsToAdd);
        else
            inventory.TryAddItem(itemId, new QuantifiedItem(unitsToAdd));
    }
}
