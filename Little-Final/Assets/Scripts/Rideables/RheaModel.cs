using UnityEngine;

namespace Rideables
{
	[CreateAssetMenu(menuName = "Models/Rhea", fileName = "RheaModel", order = 0)]
	public class RheaModel : ScriptableObject
	{
		[SerializeField]
		[Range(0, 10, step: .25f)]
		private float eatDistance = 2;

		[SerializeField]
		[Range(0, 10, step: .25f)]
		private float fleeDistance = 3;

		[SerializeField]
		[Range(0, 10, step: .25f)]
		private float patrolDistance;

		public float EatDistance => eatDistance;

		public float FleeDistance => fleeDistance;
		public float PatrolDistance => patrolDistance;
	}
}