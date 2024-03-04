using System.Collections;
using Core.Extensions;
using Core.Helpers;
using Core.Interactions;
using Core.Items;
using Sequences;
using UnityEngine;
using UnityEngine.Playables;

namespace Missions
{
    public class MissionItem : Sequence
    {
        [SerializeField] private int value = 1;
        [SerializeField] private IdContainer itemId;
        [SerializeField] private PlayableDirector cinematicDirector;
        [SerializeField] private GoToPositionInputOverride inputOverride;
        [SerializeField] private float pickRange = .3f;
        [SerializeField] private float delayBeforeAddingItem = 5;
        [SerializeField] private Color pickRangeColor = Color.yellow;

        public override void Interact(IInteractor interactor)
        {
            base.Interact(interactor);
            StartCoroutine(SequenceCoroutine(interactor));
        }

        private IEnumerator SequenceCoroutine(IInteractor interactor)
        {
            if (!inputOverride)
                yield break;
            inputOverride.Replace(transform.position, pickRange);
            yield return new WaitUntil(() => inputOverride.HasArrived);
            foreach (var track in cinematicDirector.playableAsset.outputs)
            {
                this.Log(track.streamName);
            }
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
            inputOverride.StopReplacing();
            gameObject.SetActive(false);
        }
        
        private void OnDrawGizmosSelected()
        {
            Gizmos.color = pickRangeColor;
            Gizmos.DrawSphere(transform.position, pickRange);
        }
    }
}