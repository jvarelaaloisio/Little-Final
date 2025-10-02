using UnityEngine;

namespace Core.Extensions
{
	public static class Vector3Extensions
	{
		public static Vector3 IgnoreY(this Vector3 original)
			=> new Vector3(original.x, 0, original.z);
		public static Vector3 ReplaceY(this Vector3 original, float newY)
			=> new Vector3(original.x, newY, original.z);
		public static Vector3 XZY(this Vector3 original)
			=> new Vector3(original.x, original.z, original.y);
		public static Vector2 XZtoXY(this Vector3 original)
			=> new Vector2(original.x, original.z);
	}
}