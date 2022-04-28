using UnityEngine;
using UnityEngine.Events;

namespace Events
{
	public class CollisionEventTrigger : MonoBehaviour
	{
		[SerializeField] private UnityEvent onCollisionEnterEvent;
		[SerializeField] private UnityEvent onCollisionExitEvent;
		[SerializeField] private UnityEvent onTriggerEnterEvent;
		[SerializeField] private UnityEvent onTriggerExitEvent;

		private void OnCollisionEnter(Collision other)
		{
			onCollisionEnterEvent?.Invoke();
		}

		private void OnCollisionExit(Collision other)
		{
			onCollisionExitEvent?.Invoke();
		}

		private void OnTriggerEnter(Collider other)
		{
			onTriggerEnterEvent?.Invoke();
		}

		private void OnTriggerExit(Collider other)
		{
			onTriggerExitEvent?.Invoke();
		}
	}
}