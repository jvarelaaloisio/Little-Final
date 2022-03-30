using UnityEngine;

namespace Player
{
	public interface IInteractable
	{
	}

	public interface IRideable : IInteractable
	{
		Transform GetMount();
		void Move(Vector3 direction);
	}
}