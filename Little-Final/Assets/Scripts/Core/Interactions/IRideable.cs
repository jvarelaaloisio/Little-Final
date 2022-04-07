using Core.Interactions;
using UnityEngine;

namespace Player
{
	public interface IRideable : IInteractable
	{
		Transform GetMount();
		void Mount();
		void DisMount();
		void Move(Vector3 direction);
		void UseAbility();
	}
}