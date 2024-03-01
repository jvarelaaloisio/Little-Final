using System;
using Core.Extensions;
using Core.Helpers;
using Core.Items;
using Events.Channels;
using UnityEngine;

namespace Missions.Implementations
{
    [CreateAssetMenu(menuName = "Models/Missions/Item Mission", fileName = "ItemMission", order = 0)]
    public class ItemMission : MissionContainer
    {
        [SerializeField] private IdContainer itemId;
        [SerializeField] private int quantityNeeded;
        [SerializeField] private InventoryEventChannel inventoryUpdateChannel;
        [SerializeField] private Mission _mission;

        public override Mission Get => _mission;

        private void OnEnable()
        {
            _mission = new Mission(name);
            inventoryUpdateChannel.SubscribeSafely(HandleInventoryUpdate);
        }

        private void OnDisable()
        {
            inventoryUpdateChannel.UnsubscribeSafely(HandleInventoryUpdate);
        }

        private void HandleInventoryUpdate(Inventory inventory)
        {
            if (inventory.Items.TryGetValue(itemId.Get, out var item))
            {
                this.Log($"{nameof(inventory)} updated. {item.ID.name}'s quantity: {item.Quantity}");
                if (item.Quantity >= quantityNeeded)
                {
                    Get.Complete();
                }
            }
        }
    }
}
