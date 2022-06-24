using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

namespace Rideables
{
	public class Awareness : MonoBehaviour
	{
		[SerializeField]
		private float updatePeriod = 1;

		[FormerlySerializedAs("awarenessRadius")]
		[SerializeField]
		private float playerAwarenessRadius = 1;
		
		[SerializeField]
		private float fruitAwarenessRadius = 1;

		[SerializeField]
		private LayerMask players;

		[SerializeField]
		private LayerMask fruits;

		[Header("Events")]
		[SerializeField]
		private UnityEvent onEnvironmentChanged;

		private Transform _player;
		private Transform _fruit;

		public Transform Player => _player;

		public Transform Fruit => _fruit;

		public event Action OnEnvironmentChanged = delegate { };

		private void OnEnable()
		{
			StartCoroutine(MaintainAwareness());
		}
		
		private void OnDisable()
		{
			StopCoroutine(MaintainAwareness());
		}

		//TODO: Should only do one overlapSphere and work from that. This is not a scalable solution.
		private IEnumerator MaintainAwareness()
		{
			yield return null;
			WaitForSeconds waitForPeriod = new WaitForSeconds(updatePeriod);
			while (true)
			{
				UpdateAwareness();
				yield return waitForPeriod;
			}
		}

		private void UpdateAwareness()
		{
			Collider[] candidates = new Collider[1];

			Transform fruit = Physics.OverlapSphereNonAlloc(transform.position,
															fruitAwarenessRadius,
															candidates,
															fruits,
															QueryTriggerInteraction.Collide)
							> 0
								? candidates[0].transform
								: null;
			Transform player = Physics.OverlapSphereNonAlloc(transform.position,
															playerAwarenessRadius,
															candidates,
															players)
								> 0
									? candidates[0].transform
									: null;
			bool hasChangedFlag = (_player && _player.hasChanged) || (_fruit && _fruit.hasChanged);
			if (_player) _player.hasChanged = false;
			if (_fruit) _fruit.hasChanged = false;
			bool shouldFireChangedEvent = _player != player || _fruit != fruit || hasChangedFlag;
			_player = player;
			_fruit = fruit;

			if (shouldFireChangedEvent)
			{
				onEnvironmentChanged.Invoke();
				OnEnvironmentChanged.Invoke();
			}
		}

#if UNITY_EDITOR
		[ContextMenu("Debug Awareness")]
		private void DebugAwareness()
		{
			UpdateAwareness();
			Debug.Log($"player: {_player}"
					+ $"\nfruit: {_fruit}");
		}

		private void OnDrawGizmos()
		{
			Gizmos.color = Color.yellow;
			Gizmos.DrawWireSphere(transform.position, playerAwarenessRadius);
			Gizmos.color = Color.green;
			Gizmos.DrawWireSphere(transform.position, fruitAwarenessRadius);
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(1, 1, .15f, .25f);
			Gizmos.DrawSphere(transform.position, playerAwarenessRadius);
			Gizmos.color = new Color(.35f, 1, .15f, .1f);
			Gizmos.DrawSphere(transform.position, fruitAwarenessRadius);
		}
#endif
	}
}