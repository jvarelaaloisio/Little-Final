using Core.Helpers;
using Core.Items;
using UnityEngine;

public class StaminaUpgradeStatue : MonoBehaviour
{
    [SerializeField] private Id itemId;
    [SerializeField] private int quantityForReward = 5;

    private void OnTriggerEnter(Collider other)
    {
        if (!other.TryGetComponent(out Inventory inventory))
            return;
        if (!inventory.TryGetItem(itemId, out var item))
            return;
        var simpleItem = item as QuantifiedItem;
        if (!(simpleItem?.Quantity >= quantityForReward))
            return;
        simpleItem.RemoveUnits(quantityForReward);
        Debug.Log($"{name}: reward given");
    }
}