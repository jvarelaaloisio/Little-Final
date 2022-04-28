using System;

namespace Events.Channels
{
	public static class VoidChannelHelper
	{
		public static bool SubscribeSafely(
			this VoidChannelSo channel,
			in Action handler)
		{
			if (channel) channel.Subscribe(handler);
			return channel;
		}

		public static void RaiseEventSafely(this VoidChannelSo channel)
		{
			if (channel) channel.RaiseEvent();
		}
	}
}