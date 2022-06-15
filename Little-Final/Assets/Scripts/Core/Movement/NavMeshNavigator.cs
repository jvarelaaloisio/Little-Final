using UnityEngine;
using UnityEngine.AI;

namespace Core.Movement
{
	public class NavMeshNavigator : INavigator
	{
		private readonly NavMeshAgent _agent;

		public bool HasArrived => _agent.remainingDistance <= _agent.stoppingDistance;
		
		public float ArrivalDistance { get; }

		public Vector3 Destination => _agent.destination;

		public NavMeshNavigator(NavMeshAgent agent, float arrivalDistance)
		{
			_agent = agent;
			ArrivalDistance = arrivalDistance;
		}

		public void Move(Vector3 direction)
		{
			_agent.Move(direction * _agent.speed);
		}

		public bool TrySetDestination(Vector3 destination)
		{
			return _agent.SetDestination(destination);
		}

		public float GetDistanceFromDestination()
		{
			return _agent.remainingDistance;
		}
	}
}