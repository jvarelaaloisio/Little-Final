using UnityEngine.Events;

namespace Core.Interactions
{
	public interface IDestroyable
	{
		UnityEvent OnDestroy { get; }
		void Destroy();
	}
}