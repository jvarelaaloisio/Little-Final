using System;
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

		private bool _applicationIsQuitting = false;

		public UnityEvent OnBeingDestroyed => onBeingDestroyed;

		private void OnApplicationQuit()
		{
			_applicationIsQuitting = true;
		}

		[ContextMenu("Destroy")]
		public void Destroy()
		{
			Destroy(gameObject);
		}

		private void OnDestroy()
		{
			if (!_applicationIsQuitting)
				onBeingDestroyed.Invoke();
		}
	}
}