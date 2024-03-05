using System.Collections;
using Core.Helpers;
using Core.Interactions;
using Core.Items;
using UnityEngine;

namespace Missions
{
    public class ItemPoint : Sequence
    {
        [SerializeField] private int value = 1;
        [SerializeField] private IdContainer itemId;
        [SerializeField] private float delayBeforeAddingItem = 5;

        private void OnEnable()
        {
            onFinishedSequence += HandleFinished;
        }
        
        private void OnDisable()
        {
            onFinishedSequence -= HandleFinished;
        }

        protected override IEnumerator SequenceInternal(IInteractor interactor)
        {
            cinematicDirector.Play();
            yield return new WaitForSeconds(delayBeforeAddingItem);
            if (interactor.transform.TryGetComponent(out Inventory inventory))
            {
                if (!inventory.TryAddItem(itemId.Get, new QuantifiedItem(value)))
                    inventory.Items[itemId.Get].AddUnit(new QuantifiedItem(value));
            }
            var durationAfterAddDelay = (float)cinematicDirector.duration - delayBeforeAddingItem;
            if (durationAfterAddDelay > 0)
                yield return new WaitForSeconds(durationAfterAddDelay);
        }

        private void HandleFinished()
        {
            gameObject.SetActive(false);
        }
    }
}