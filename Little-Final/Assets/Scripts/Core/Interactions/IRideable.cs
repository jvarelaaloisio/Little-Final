using UnityEngine;

namespace Player
{
	public interface IRideable : IInteractable
	{
		Transform GetMount();
		void Move(Vector3 direction);
		void UseAbility();
	}
}