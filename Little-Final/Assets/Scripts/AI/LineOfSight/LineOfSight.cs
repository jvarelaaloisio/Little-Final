using UnityEngine;

namespace AI.LineOfSight
{
	public static class LineOfSight
	{
		public static bool IsTargetOnSight(Transform searcher,
											Vector3 targetPosition,
											float viewDistance,
											float fieldOfView,
											LayerMask walls)
		{
			Vector3 connection = targetPosition - searcher.position;
			if (connection.magnitude > viewDistance
				|| Vector3.Angle(searcher.forward, connection.normalized) > fieldOfView / 2)
				return false;
			if (Physics.Raycast(searcher.position,
								connection.normalized,
								out _,
								connection.magnitude,
								walls))
			{
				Debug.DrawRay(searcher.position, connection, Color.magenta);
				return false;
			}
			return true;
		}

		public static bool IsTargetOnSight(Transform searcher, Vector3 targetPosition, SightModel model) =>
			IsTargetOnSight(searcher, targetPosition, model.ViewDistance, model.FieldOfView, model.Walls);
	}
}