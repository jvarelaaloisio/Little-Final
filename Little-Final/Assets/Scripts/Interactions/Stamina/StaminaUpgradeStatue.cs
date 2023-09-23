using Core.Helpers;
using Core.Interactions;
using Core.Items;
using Player;
using UnityEngine;

public class StaminaUpgradeStatue : MonoBehaviour, IInteractable
{
    [SerializeField] private IdContainer itemIdContainer;
    [SerializeField] private int quantityForReward = 5;
    [SerializeField] private int upgradeSize;

    public void Interact(IInteractor interactor)
    {
        var interactorTransform = interactor.transform;
        if (!interactorTransform.TryGetComponent(out Inventory inventory))
            return;
        if (!inventory.TryGetItem(itemIdContainer.Get, out var item))
            return;
        // var simpleItem = item as QuantifiedItem;
        if (!(item?.Quantity >= quantityForReward))
            return;
        if (!interactorTransform.TryGetComponent(out PlayerController playerController))
            return;
        var stamina = playerController.Stamina;
        stamina.UpgradeMaxStamina(stamina.MaxStamina + upgradeSize);
        item.RemoveUnit(new QuantifiedItem(quantityForReward));
        Debug.Log($"{name}: Stamina reward given ({upgradeSize})");
    }

    public void Leave()
    {
        throw new System.NotImplementedException();
    }
}