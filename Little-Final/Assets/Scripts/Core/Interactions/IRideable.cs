using UnityEngine;

namespace Core.Interactions
{
	public interface IRideable : IInteractable
	{
		Transform GetMount();
		void Move(Vector3 direction);
		void UseAbility();
	}
}