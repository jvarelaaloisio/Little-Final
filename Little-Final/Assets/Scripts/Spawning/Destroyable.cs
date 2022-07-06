using Core.Debugging;
using Core.Interactions;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

namespace Spawning
{
	[AddComponentMenu("Spawning/Destroyable")]
	public class Destroyable : MonoBehaviour, IDestroyable
	{
		private const string DEBUG_TAG = "Destroyable";

		[FormerlySerializedAs("onDestroy")]
		[SerializeField]
		private UnityEvent onBeingDestroyed;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;
		
		private bool _applicationIsQuitting = false;

		public UnityEvent OnBeingDestroyed => onBeingDestroyed;

		private void OnApplicationQuit()
		{
			_applicationIsQuitting = true;
		}

		private void OnDestroy()
		{
			if (!_applicationIsQuitting)
				onBeingDestroyed.Invoke();
		}

		[ContextMenu("Destroy")]
		public void Destroy()
		{
			debugger.LogSafely(DEBUG_TAG, $"Destroying gameObject {gameObject.name}", this);
			Destroy(gameObject);
		}
	}
}