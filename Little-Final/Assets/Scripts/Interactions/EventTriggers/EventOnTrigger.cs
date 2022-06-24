using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Interactions.EventTriggers
{
	public class EventOnTrigger : MonoBehaviour
	{
		[SerializeField]
		private List<string> tagBlackList;
		
		[System.Serializable]
		public class ColliderUnityEvent : UnityEvent<Collider> { }
		[SerializeField] private ColliderUnityEvent onTriggerEnter;
		[SerializeField] private ColliderUnityEvent onTriggerExit;

		public void SubscribeToEnter(UnityAction<Collider> listener)
		{
			onTriggerEnter.AddListener(listener);
		}
		public void UnsubscribeFromEnter(UnityAction<Collider> listener)
		{
			onTriggerEnter.RemoveListener(listener);
		}
		public void SubscribeToExit(UnityAction<Collider> listener)
		{
			onTriggerExit.AddListener(listener);
		}
		public void UnsubscribeFromExit(UnityAction<Collider> listener)
		{
			onTriggerExit.RemoveListener(listener);
		}
		private void OnTriggerEnter(Collider other)
		{
			if (!tagBlackList.Contains(other.tag))
				onTriggerEnter.Invoke(other);
		}

		private void OnTriggerExit(Collider other)
		{
			if (!tagBlackList.Contains(other.tag))
				onTriggerExit.Invoke(other);
		}
	}
}
