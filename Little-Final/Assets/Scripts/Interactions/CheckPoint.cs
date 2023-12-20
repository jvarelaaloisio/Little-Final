using Player;
using UnityEngine;

namespace Interactions
{
	public class CheckPoint : MonoBehaviour
	{
		public float distanceFromFloor;
		[SerializeField]
		public Vector3 safePoint;
		[SerializeField, HideInInspector]
		public Quaternion safeRotation;

		[Header("Debug")]
		[SerializeField]
		private bool shouldLogCheckpointUpdate = false;


		private void OnTriggerEnter(Collider other)
		{
			if (other.TryGetComponent<PlayerController>(out var controller))
			{
				if (shouldLogCheckpointUpdate)
					Debug.Log($"updated checkpoint to pos: {safePoint} and rot: {safeRotation}");
				controller.SaveSafeState(safePoint, safeRotation);
			}
		}

		private void OnDrawGizmos()
		{
			Gizmos.color = Color.blue;
			Gizmos.DrawWireSphere(safePoint, .2f);
		}

		[ContextMenu("Reset safe rotation")]
		private void ResetSafeRotation()
			=> safeRotation = Quaternion.identity;
	}
}