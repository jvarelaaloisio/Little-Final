using UnityEngine;
using UnityEngine.Events;

namespace Interactions.EventTriggers
{
	public class EventOnCollision : MonoBehaviour
	{
		[SerializeField]
		private CollisionUnityEvent onCollisionEnter;

		[SerializeField]
		private CollisionUnityEvent onCollisionExit;

		public void SubscribeToEnter(UnityAction<Collision> listener) => onCollisionEnter.AddListener(listener);

		public void UnsubscribeFromEnter(UnityAction<Collision> listener) => onCollisionEnter.RemoveListener(listener);

		public void SubscribeToExit(UnityAction<Collision> listener) => onCollisionExit.AddListener(listener);

		public void UnsubscribeFromExit(UnityAction<Collision> listener) => onCollisionExit.RemoveListener(listener);


		private void OnCollisionEnter(Collision collision) => onCollisionEnter.Invoke(collision);
		private void OnCollisionExit(Collision collision) => onCollisionExit.Invoke(collision);
	}
}