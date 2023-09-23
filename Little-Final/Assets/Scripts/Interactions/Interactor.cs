using System;
using System.Collections.Generic;
using Core.Interactions;
using UnityEngine;

public class Interactor : MonoBehaviour, IInteractor
{
    private List<IInteractable> _interactables;

    public void LoseInteraction()
    {
        throw new System.NotImplementedException();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.TryGetComponent(out IInteractable interactable))
        {
            _interactables.Add(interactable);
        }
        
    }
}