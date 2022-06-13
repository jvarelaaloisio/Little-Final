using UnityEngine.Events;

namespace Core.Interactions
{
	public interface IDestroyable
	{
		UnityEvent OnBeingDestroyed { get; }
		void Destroy();
	}
}