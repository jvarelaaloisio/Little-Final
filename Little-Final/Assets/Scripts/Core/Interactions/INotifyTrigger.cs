using UnityEngine;
using UnityEngine.Events;

namespace Interactions.EventTriggers
{
	public interface INotifyTrigger
	{
		void SubscribeToEnter(UnityAction<Collider> listener);
		void UnsubscribeFromEnter(UnityAction<Collider> listener);
		void SubscribeToExit(UnityAction<Collider> listener);
		void UnsubscribeFromExit(UnityAction<Collider> listener);
	}
}