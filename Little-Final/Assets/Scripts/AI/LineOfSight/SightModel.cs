using UnityEngine;

namespace AI.LineOfSight
{
	[CreateAssetMenu(menuName = "Models/AI/Sight", fileName = "SightModel", order = 0)]
	public class SightModel : ScriptableObject
	{
		[SerializeField]
		private float viewDistance;

		[SerializeField]
		private float fieldOfView;

		[SerializeField]
		private LayerMask walls;

		public float ViewDistance => viewDistance;

		public float FieldOfView => fieldOfView;

		public LayerMask Walls => walls;
	}
}