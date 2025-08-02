using UnityEngine;

namespace Characters
{
	public class FloorTracker : MonoBehaviour, IFloorTracker
	{
		[SerializeField] private float maxFloorTrackingDistance = 100f;
		[SerializeField] private LayerMask floor;
		private RaycastHit _currentFloorData;
		public bool HasFloor { get; private set; }

		public RaycastHit CurrentFloorData => _currentFloorData;

		protected void FixedUpdate()
			=> HasFloor = Physics.Raycast(transform.position, -transform.up, out _currentFloorData, maxFloorTrackingDistance, floor);

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = Color.blue;
			if (HasFloor)
			{
				Gizmos.DrawRay(CurrentFloorData.point, CurrentFloorData.normal * 0.2f);
				return;
			}
			Gizmos.DrawRay(transform.position, -transform.up * maxFloorTrackingDistance);
		}
	}
}