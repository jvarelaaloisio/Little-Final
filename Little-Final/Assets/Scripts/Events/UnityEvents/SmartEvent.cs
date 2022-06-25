using System;
using UnityEngine;
using UnityEngine.Events;

namespace Events.UnityEvents
{
	[System.Serializable]
	public class SmartEvent : UnityEvent
	{
		private event Action OnEventInternal;

		public SmartEvent()
		{
			OnEventInternal = RaiseEvent;
		}

		[ContextMenu("Raise Event")]
		private void RaiseEvent()
		{
			base.Invoke();
		}
		
		public static implicit operator Action(SmartEvent original) => original.OnEventInternal;
		public static SmartEvent operator +(SmartEvent original, Action action)
		{
			original.AddListener(action.Invoke);
			return original;
		}
	}
}