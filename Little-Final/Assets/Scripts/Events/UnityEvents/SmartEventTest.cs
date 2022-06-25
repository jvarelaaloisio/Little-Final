using System;
using UnityEngine;

namespace Events.UnityEvents
{
	public class SmartEventTest : MonoBehaviour
	{
		[SerializeField]
		private SmartEvent mySmartEvent;
		[ContextMenu("Invoke From UnityEvent")]
		private void InvokeFromUnityEvent()
		{
			mySmartEvent.Invoke();
			((Action)mySmartEvent)();
		}
		[ContextMenu("Invoke From Action")]
		private void InvokeFromAction()
		{
			mySmartEvent += AdditionalBehaviour;
			Action action = mySmartEvent;
			action();
		}

		private void AdditionalBehaviour()
			=> Debug.Log("This Action was added after");
	}
}