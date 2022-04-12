using UnityEngine;

namespace Core.Interactions
{
	public interface IInteractable
	{
		void Interact(Transform user);
		void Leave();
	}
}