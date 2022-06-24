using Core.Debugging;
using Core.Interactions;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Spawning
{
	[AddComponentMenu("Spawning/Simple Spawner")]
	public class SimpleSpawner : MonoBehaviour
	{
		[SerializeField]
		private GameObject prefab;

		[SerializeField]
		private Debugger debugger;

		private void Start()
		{
			Spawn();
		}

		private void Spawn()
		{
			debugger.Log(name, $"Spawning\nPrefab: {prefab.name}");
			GameObject instance = Instantiate(prefab, transform.position, transform.rotation);
			SceneManager.MoveGameObjectToScene(instance, gameObject.scene);
			if (!instance.TryGetComponent(out IDestroyable destroyable))
				destroyable = instance.AddComponent<Destroyable>();

			destroyable.OnBeingDestroyed.AddListener(Spawn);
		}

		private void OnDrawGizmosSelected()
		{
			if (Physics.Raycast(transform.position,
								Vector3.down,
								out var hit,
								100))
			{
				Gizmos.color = new Color(1, .35f, 0);
				Gizmos.DrawLine(transform.position, hit.point);
				Gizmos.DrawSphere(hit.point, .25f);
			}
		}
	}
}