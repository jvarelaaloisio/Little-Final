using System.Collections;
using UnityEngine;
using UnityEngine.Events;

namespace Events
{
	public class RaiseEventAfterDelay : MonoBehaviour
	{
		[SerializeField]
		private UnityEvent onEvent;
		
		[Space]
		[Header("Fire On Start")]
		[SerializeField]
		private bool fireOnStart = false;

		[SerializeField]
		[Tooltip("Delay before event when firing on Start, in seconds.")]
		private float delay = 1;

		private IEnumerator Start()
		{
			if (!fireOnStart)
				yield break;
			yield return new WaitForSeconds(delay);
			RaiseEvent();
		}

		public void RaiseEventAfter(float delay)
		{
			Invoke(nameof(RaiseEvent), delay);
		}

		private void RaiseEvent()
		{
			onEvent.Invoke();
		}
	}
}
