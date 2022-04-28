using System;
using Events.Channels;
using Events.UnityEvents;
using UnityEngine;
using UnityEngine.Serialization;

namespace Events
{
	public class StringChannelPropagator : MonoBehaviour 
	{
		[FormerlySerializedAs("channel")]
		[SerializeField, Tooltip("Not Null")]
		private StringEventChannel eventChannel;
		
		public StringUnityEvent onEvent;

		private void Awake()
		{
			try
			{
				eventChannel.Subscribe(onEvent.Invoke);
			}
			catch (NullReferenceException)
			{
				throw new NullReferenceException($"No channel was provided for the propagation" +
												$" in the {gameObject.name} GameObject");
			}
		}
	}
}