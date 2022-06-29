using System.Collections;
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
		private float spawnDelay;
		
		[SerializeField]
		private Debugger debugger;

		private void Start()
		{
			StartCoroutine(Spawn());
		}

		private IEnumerator Spawn()
		{
			yield return new WaitForSeconds(spawnDelay);
			debugger.Log(name, $"Spawning\nPrefab: {prefab.name}");
			GameObject instance = Instantiate(prefab, transform.position, transform.rotation);
			SceneManager.MoveGameObjectToScene(instance, gameObject.scene);
			if (!instance.TryGetComponent(out IDestroyable destroyable))
				destroyable = instance.AddComponent<Destroyable>();

			destroyable.OnBeingDestroyed.AddListener(() => StartCoroutine(Spawn()));
			yield break;
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