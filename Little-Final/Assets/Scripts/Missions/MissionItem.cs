using Core.Helpers;
using Core.Interactions;
using Core.Items;
using UnityEngine;

namespace Missions
{
    public class MissionItem : Sequence
    {
        [SerializeField] private int value = 1;
        [SerializeField] private IdContainer itemId;

        public override void Interact(IInteractor interactor)
        {
            base.Interact(interactor);
            if (interactor.transform.TryGetComponent(out Inventory inventory))
            {
                if (!inventory.TryAddItem(itemId.Get, new QuantifiedItem(value)))
                    inventory.Items[itemId.Get].AddUnit(new QuantifiedItem(value));
            }
        }
    }
}