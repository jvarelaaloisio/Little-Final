using System;
using System.Collections.Generic;
using Core.Helpers;
using Events.Channels;
using UnityEngine;
using UnityEngine.Events;

namespace Core.Items
{
    public class Inventory : MonoBehaviour
    {
        public Dictionary<IIdentifier, Item> Items { get; } = new();
        public event Action<IIdentifier, Item> onItemAdded = delegate { };
        [SerializeField] private UnityEvent<IIdentifier, Item> OnItemAdded;
        
        [SerializeField] private InventoryEventChannel inventoryUpdateChannel;

        private void OnValidate()
        {
            onItemAdded += OnItemAdded.Invoke;
        }

        /// <summary>
        /// Searchs for an item in the inventory.
        /// </summary>
        /// <param name="itemId">ID to filter with</param>
        /// <param name="item">The item found. May be null</param>
        /// <returns>true if has item</returns>
        public bool TryGetItem(IIdentifier itemId, out Item item)
            => Items.TryGetValue(itemId, out item);

        /// <summary>
        /// Adds an item if it doesn't have it already.
        /// </summary>
        /// <param name="itemId">ID to filter with</param>
        /// <param name="item">Item to set the new value to</param>
        /// <returns>true if added. False if already existed</returns>
        public bool TryAddItem(IIdentifier itemId, Item item)
        {
            if (!Items.TryAdd(itemId, item))
                return false;
            item.ID = itemId;
            item.onQuantityChanged += HandleItemUpdate;
            onItemAdded(itemId, item);
            inventoryUpdateChannel.RaiseEventSafely(this);
            return true;

        }

        private void HandleItemUpdate(int before, int after)
        {
            inventoryUpdateChannel.RaiseEventSafely(this);
        }
    }
}