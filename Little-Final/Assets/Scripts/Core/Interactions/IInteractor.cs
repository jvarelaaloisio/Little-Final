using UnityEngine;

namespace Core.Interactions
{
	public interface IInteractor
	{
		Transform Transform { get; }
		void LoseInteraction();
	}
}