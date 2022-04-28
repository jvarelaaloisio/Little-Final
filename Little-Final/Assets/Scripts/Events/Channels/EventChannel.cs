using System;
using UnityEngine;

namespace Events.Channels
{
	public abstract class EventChannel<T> : ScriptableObject
	{
		private Action<T> dataEvent;

		public void Subscribe(in Action<T> handler)
		{
			dataEvent += handler;
		}

		public void Unsubscribe(in Action<T> handler)
		{
			dataEvent -= handler;
		}

		public void RaiseEvent(T data) => dataEvent?.Invoke(data);
	}

	public abstract class EventChannel<T1, T2> : ScriptableObject
	{
		private Action<T1, T2> dataEvent;

		public void Subscribe(in Action<T1, T2> handler)
		{
			dataEvent += handler;
		}

		public void Unsubscribe(in Action<T1, T2> handler)
		{
			dataEvent -= handler;
		}

		public void RaiseEvent(T1 data1, T2 data2) => dataEvent?.Invoke(data1, data2);
	}

	public abstract class EventChannel<T1, T2, T3> : ScriptableObject
	{
		private Action<T1, T2, T3> dataEvent;

		public void Subscribe(in Action<T1, T2, T3> handler)
		{
			dataEvent += handler;
		}

		public void Unsubscribe(in Action<T1, T2, T3> handler)
		{
			dataEvent -= handler;
		}

		public void RaiseEvent(T1 data1, T2 data2, T3 data3) => dataEvent?.Invoke(data1, data2, data3);
	}

	public abstract class EventChannel<T1, T2, T3, T4> : ScriptableObject
	{
		private Action<T1, T2, T3, T4> dataEvent;

		public void Subscribe(in Action<T1, T2, T3, T4> handler)
		{
			dataEvent += handler;
		}

		public void Unsubscribe(in Action<T1, T2, T3, T4> handler)
		{
			dataEvent -= handler;
		}

		public void RaiseEvent(T1 data1, T2 data2, T3 data3, T4 data4) => dataEvent?.Invoke(data1, data2, data3, data4);
	}

	public abstract class EventChannel<T1, T2, T3, T4, T5> : ScriptableObject
	{
		private Action<T1, T2, T3, T4, T5> dataEvent;

		public void Subscribe(in Action<T1, T2, T3, T4, T5> handler)
		{
			dataEvent += handler;
		}

		public void Unsubscribe(in Action<T1, T2, T3, T4, T5> handler)
		{
			dataEvent -= handler;
		}

		public void RaiseEvent(T1 data1, T2 data2, T3 data3, T4 data4, T5 data5) =>
			dataEvent?.Invoke(data1, data2, data3, data4, data5);
	}
}