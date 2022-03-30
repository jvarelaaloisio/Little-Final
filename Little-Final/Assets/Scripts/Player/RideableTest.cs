using UnityEngine;

namespace Player
{
	public class RideableTest : MonoBehaviour, IRideable
	{
		public Transform GetMount()
		{
			return transform;
		}

		public void Move(Vector3 direction)
		{
			
		}
	}
}