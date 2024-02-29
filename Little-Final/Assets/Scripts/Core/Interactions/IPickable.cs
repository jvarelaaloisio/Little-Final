using UnityEngine;

namespace Core.Interactions
{
	public interface IPickable : IInteractable
	{
		void Throw(Vector3 scaledDirection);
	}
}