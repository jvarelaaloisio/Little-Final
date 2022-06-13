using UnityEngine;

namespace Core.Movement
{
	public interface INavigator
	{
		void Move(Vector3 direction);
		bool TrySetDestination(Vector3 destination);
		float GetDistanceFromDestination();
		bool HasArrived { get; }
		Vector3 Destination { get; }
		float ArrivalDistance { get; }
	}
}