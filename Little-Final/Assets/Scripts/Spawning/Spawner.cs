using System;
using System.Collections;
using Core.Extensions;
using Core.Interactions;
using UnityEngine;

namespace Interactions
{
	public class Spawner : MonoBehaviour
	{
		[SerializeField]
		private GameObject prefab;

		[SerializeField]
		private Transform spawnPoint;

		[SerializeField]
		private float spawnPeriod;

		[SerializeField]
		private float activeRadius;

		[SerializeField]
		private bool radiusIs2d;

		[SerializeField]
		private Transform player;

		private bool _isSpawning;

		private void OnValidate()
		{
			if (!player)
				player = GameObject.FindGameObjectWithTag("Player").transform;
		}

		private void Reset()
		{
			Debug.Log("Reset is running");
		}

		private void OnEnable()
		{
			bool ShouldSpawn() => (radiusIs2d &&
									Vector3.Distance(transform.position.XZtoXY(), player.position.XZtoXY())
									< activeRadius)
								|| Vector3.Distance(transform.position, player.position) < activeRadius;

			StartCoroutine(Spawn(prefab,
								spawnPoint.position,
								spawnPoint.rotation,
								spawnPeriod,
								ShouldSpawn));
		}

		private void OnDisable()
		{
			StopCoroutine(nameof(Spawn));
		}

		private static IEnumerator Spawn(GameObject prefab,
										Vector3 position,
										Quaternion rotation,
										float period,
										Func<bool> shouldSpawn)
		{
			WaitForSeconds waitForPeriod = new WaitForSeconds(period);
			while (true)
			{
				if (shouldSpawn()) Instantiate(prefab, position, rotation);
				yield return waitForPeriod;
			}
		}

		private void OnDrawGizmos()
		{
			Vector3 gizmoPosition = transform.position;
			if (Physics.Raycast(transform.position, Vector3.down, out var hit, 50))
				gizmoPosition = hit.point + Vector3.up * activeRadius / 2;
			Gizmos.color = new Color(1, .5f, .5f, .25f);
			Gizmos.DrawSphere(gizmoPosition, .25f);
			Gizmos.DrawWireSphere(gizmoPosition, activeRadius);
		}

		private void OnDrawGizmosSelected()
		{
			Vector3 gizmoPosition = transform.position;
			if (Physics.Raycast(transform.position, Vector3.down, out var hit, 50))
				gizmoPosition = hit.point + Vector3.up * activeRadius / 2;
			Gizmos.color = new Color(1, .5f, .5f);
			Gizmos.DrawSphere(gizmoPosition, .25f);
			Gizmos.DrawWireSphere(gizmoPosition, activeRadius);
		}
	}
}