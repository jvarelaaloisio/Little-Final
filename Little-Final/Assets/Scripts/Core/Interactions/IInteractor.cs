using UnityEngine;

namespace Core.Interactions
{
	public interface IInteractor
	{
		Transform transform { get; }
		void LoseInteraction();
	}
}