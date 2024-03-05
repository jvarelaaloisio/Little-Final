using System.Collections;
using Core.Extensions;
using Core.Interactions;
using Events.UnityEvents;
using Sequences;
using UnityEngine;
using UnityEngine.Playables;

namespace Missions
{
    public abstract class Sequence : MonoBehaviour, IInteractable
    {
        [SerializeField] protected PlayableDirector cinematicDirector;
        [SerializeField] protected GoToPositionInputOverride inputOverride;
        [SerializeField] private float interactRange = .3f;
        [SerializeField] private Color rangeColor = Color.yellow;
        [SerializeField] private Transform playerSpot;
        protected Coroutine sequenceCoroutine;

        [SerializeField] public SmartEvent onFinishedSequence;

        public void Interact(IInteractor interactor)
        {
            sequenceCoroutine = StartCoroutine(SequenceCoroutine(interactor));
        }

        public virtual void Leave()
        {
            //TODO: Interactor.StopSequence()
        }

        private IEnumerator SequenceCoroutine(IInteractor interactor)
        {
            if (!inputOverride)
                yield break;

            var playerTargetSpot = playerSpot ? playerSpot.position : transform.position;
            Vector3 smallOffset = playerSpot ? (playerSpot.position - transform.position).IgnoreY() * .25f : Vector3.zero;
            inputOverride.Replace(playerTargetSpot + smallOffset, interactRange);
            yield return new WaitUntil(() => inputOverride.HasArrived);
            if (playerSpot)
            {
                inputOverride.SetDestination(playerTargetSpot);
                yield return new WaitUntil(() => inputOverride.HasArrived);
            }
            foreach (var track in cinematicDirector.playableAsset.outputs)
            {
                this.Log(track.streamName);
            }

            yield return SequenceInternal(interactor);
            onFinishedSequence.Invoke();
            inputOverride.StopReplacing();
        }

        protected abstract IEnumerator SequenceInternal(IInteractor interactor);

        private void OnDrawGizmosSelected()
        {
            Gizmos.color = rangeColor;
            var spot = playerSpot ? playerSpot.position : transform.position;
            Gizmos.DrawSphere(spot, interactRange);
        }
    }
}