using UnityEngine;

namespace Core.Extensions
{
	public static class Vector2Extensions
	{
		public static Vector3 HorizontalPlaneToVector3(this Vector2 original, float newY = 0)
			=> new Vector3(original.x, newY, original.y);
	}
}