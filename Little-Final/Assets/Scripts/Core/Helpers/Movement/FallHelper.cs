using Boo.Lang;
using UnityEngine;

namespace CharacterMovement
{
	public static class FallHelper
	{
		private static readonly List<GameObject> floors = new List<GameObject>();
		public static bool IsGrounded => floors.Count > 0;
		public static void AddFloor(GameObject floor)
		{
			if (!floors.Contains(floor))
			{
				floors.Add(floor);
			}
		}
		public static void RemoveFloor(GameObject floor)
		{
			if (floors.Contains(floor))
			{
				floors.Remove(floor);
			}
		}
	}

}