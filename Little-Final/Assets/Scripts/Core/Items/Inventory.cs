using System;
using System.Collections.Generic;
using Core.Helpers;
using UnityEngine;
using UnityEngine.Events;

namespace Core.Items
{
    public class Inventory : MonoBehaviour
    {
        public Dictionary<Id, Item> Items { get; } = new();
        public event Action<Id, Item> onItemAdded = delegate { };
        [SerializeField] private UnityEvent<Id, Item> OnItemAdded;

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
        public bool TryGetItem(Id itemId, out Item item) => Items.TryGetValue(itemId, out item);

        /// <summary>
        /// Adds an item if it doesn't have it already.
        /// </summary>
        /// <param name="itemId">ID to filter with</param>
        /// <param name="item">Item to set the new value to</param>
        /// <returns>true if added. False if already existed</returns>
        public bool TryAddItem(Id itemId, Item item)
        {
            if (Items.ContainsKey(itemId))
            {
                return false;
            }
            Items.Add(itemId, item);
            onItemAdded(itemId, item);
            return true;
        }
    }
}