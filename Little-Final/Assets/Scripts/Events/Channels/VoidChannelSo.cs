using System;
using UnityEngine;
using UnityEngine.Events;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Void Channel", fileName = "VoidChannel")]
	public class VoidChannelSo : ScriptableObject
	{
		private Action voidEvent;

		public void Subscribe(in Action handler)
		{
			voidEvent += handler;
		}

		public void Unsubscribe(in Action handler)
		{
			voidEvent -= handler;
		}

		public void RaiseEvent()
		{
			voidEvent?.Invoke();
		}
	}
}