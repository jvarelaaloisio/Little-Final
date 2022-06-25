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
		[FormerlySerializedAs("onDestroy")]
		[SerializeField]
		private UnityEvent onBeingDestroyed;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;
		
		private bool _applicationIsQuitting = false;

		public UnityEvent OnBeingDestroyed => onBeingDestroyed;

		private string DebugTag => name + " (Destroyable)";

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
			debugger.Log(DebugTag, $"Destroying gameObject {gameObject.name}", this);
			Destroy(gameObject);
		}
	}
}