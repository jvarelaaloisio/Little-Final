using Events.Channels;
using UnityEngine;

namespace Core.Items
{
    [CreateAssetMenu(menuName = "Event Channels/Data Channels/Inventory", fileName = "InventoryDataChannel", order = 0)]
    public class InventoryEventChannel : EventChannel<Inventory> { }
}
