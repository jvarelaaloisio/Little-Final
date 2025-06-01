using UnityEngine;

namespace Characters
{
	public interface IFloorTracker
	{
		bool HasFloor { get; }
		RaycastHit CurrentFloorData { get; }
	}
}