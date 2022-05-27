using Core.Interactions;
using UnityEngine;
using UnityEngine.Events;

namespace Spawning
{
	[AddComponentMenu("Spawning/Destroyable")]
	public class Destroyable : MonoBehaviour, IDestroyable
	{
		[SerializeField]
		private UnityEvent onDestroy;

		public UnityEvent OnDestroy => onDestroy;

		public void Destroy()
		{
			onDestroy.Invoke();
			Destroy(gameObject);
		}
	}
}