using System;
using Core.Extensions;
using Core.Helpers;
using Core.Items;
using Events.Channels;
using Events.UnityEvents;
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
        public Action<int> onItemQtyChanged;
        public Action<Mission, int> onMissionAdded;
        

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

        public override Mission Add()
        {
            onMissionAdded.Invoke(_mission, quantityNeeded);
            return base.Add();
        }

        private void HandleInventoryUpdate(Inventory inventory)
        {
            if (!inventory.Items.TryGetValue(itemId.Get, out var item))
                return;
            onItemQtyChanged.Invoke(item.Quantity);
            this.Log($"{nameof(inventory)} updated. {item.ID.name}'s quantity: {item.Quantity}");
            if (item.Quantity >= quantityNeeded)
            {
                Get.Complete();
            }
        }
    }
}
