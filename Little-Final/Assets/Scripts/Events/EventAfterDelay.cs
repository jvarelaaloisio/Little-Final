using System.Collections;
using UnityEngine;
using UnityEngine.Events;

namespace Events
{
	[AddComponentMenu("Events/Fire Event After Delay")]
	public class EventAfterDelay : MonoBehaviour
	{
		[Header("Setup")]
		[SerializeField]
		private float delay;

		[SerializeField]
		private bool destroyComponentAfterEvent = false;

		[SerializeField, TextArea] private string description;
		
		[Header("Events")]
		[SerializeField]
		private UnityEvent onEvent;

		private void Start()
		{
			StartCoroutine(FireEventAfter(delay));
		}

		private IEnumerator FireEventAfter(float seconds)
		{
			yield return new WaitForSeconds(seconds);
			onEvent.Invoke();
			if (destroyComponentAfterEvent)
			{
				Destroy(this);
			}
		}
	}
}
