using System;

namespace Events.Channels
{
	public static class SimpleDataChannelHelper
	{
		public static void SubscribeSafely<T>(
			this EventChannel<T> eventChannel,
			in Action<T> handler)
		{
			if (eventChannel) eventChannel.Subscribe(handler);
		}
		
		public static bool UnsubscribeSafely<T>(
			this EventChannel<T> channel,
			in Action<T> handler)
		{
			if (channel) channel.Unsubscribe(handler);
			return channel;
		}

		public static void RaiseEventSafely<T>(
			this EventChannel<T> eventChannel,
			in T data)
		{
			if (eventChannel) eventChannel.RaiseEvent(data);
		}
	}
}