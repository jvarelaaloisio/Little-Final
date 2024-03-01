using Core.Interactions;
using UnityEngine;

namespace Missions
{
    public class Sequence : MonoBehaviour, IInteractable
    {

        public virtual void Interact(IInteractor interactor)
        {
            //TODO: Interactor.StartSequence()
        }

        public virtual void Leave()
        {
            //TODO: Interactor.StopSequence()
        }
    }
}