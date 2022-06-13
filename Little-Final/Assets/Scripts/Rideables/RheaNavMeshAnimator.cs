using UnityEngine;
using UnityEngine.AI;

namespace Rideables
{
	public class RheaNavMeshAnimator : RheaAnimatorView
	{
		[SerializeField]
		private NavMeshAgent navMeshAgent;

		[Tooltip("Modify this value to get a more consistent representation between rigidBody and NavMesh view")]
		[SerializeField]
		private float speedModifier = 1;

		protected override Vector3 GetSpeed() => navMeshAgent.velocity * speedModifier;

		protected override void OnValidate()
		{
			base.OnValidate();
			if (!navMeshAgent)
				TryGetComponent(out navMeshAgent);
			if (!navMeshAgent)
				transform.parent.TryGetComponent(out navMeshAgent);
		}

		protected override void Awake()
		{
			base.Awake();
			if (!navMeshAgent)
				Debug.LogError("NavMeshAgent field not set", this);
		}
	}
}