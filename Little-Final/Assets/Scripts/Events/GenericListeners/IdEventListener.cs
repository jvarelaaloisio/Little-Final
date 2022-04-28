using Events.Channels;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

namespace Events.GenericListeners
{
	public class IdEventListener : MonoBehaviour
	{
		[SerializeField] private int id;
		[FormerlySerializedAs("channel")]
		[FormerlySerializedAs("dataChannel")] [SerializeField, Tooltip("Not Null")] private IntEventChannel eventChannel;
		[SerializeField] private UnityEvent onEvent;

		private void Awake()
		{
			eventChannel.Subscribe(listenedId =>
			{
				if (listenedId == id) onEvent.Invoke();
			});
		}

		public void Debug() => UnityEngine.Debug.Log("event raised with id: " + id);
	}
}