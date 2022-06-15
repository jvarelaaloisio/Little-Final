using System;
using System.Collections.Generic;
using Core.Debugging;
using UnityEngine;
using UnityEngine.AI;

namespace Rideables.States
{
	[Obsolete]
	public class WalkOnNavMesh<T> : CharacterState<T>
	{
		private readonly NavMeshAgent _agent;
		private readonly IEnumerable<Vector3> _getCandidatePosition;

		public WalkOnNavMesh(string name,
							Transform transform,
							Action onCompletedObjective,
							Debugger debugger,
							NavMeshAgent agent,
							IEnumerable<Vector3> getCandidatePosition)
			: base(name, transform, onCompletedObjective, debugger)
		{
			_agent = agent;
			_getCandidatePosition = getCandidatePosition;
		}

		public override void Awake()
		{
			using (IEnumerator<Vector3> getCandidate = _getCandidatePosition.GetEnumerator())
			{
				base.Awake();
				while (!_agent.SetDestination(getCandidate.Current))
				{
					Debugger.Log(MyTransform.name, getCandidate.Current + " wasn't a good call");
					if (!getCandidate.MoveNext()) break;
				}
			}
		}
	}
}