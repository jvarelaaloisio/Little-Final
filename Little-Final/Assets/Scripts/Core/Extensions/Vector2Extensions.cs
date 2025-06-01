using UnityEngine;

namespace Core.Extensions
{
	public static class Vector2Extensions
	{
		/// <summary>
		/// X => original.x<br/>
		/// Y => newY<br/>
		/// Z => original.y<br/>
		/// </summary>
		/// <param name="original"></param>
		/// <param name="newY">the Y value for the Vector3 result</param>
		/// <returns></returns>
		public static Vector3 HorizontalPlaneToVector3(this Vector2 original, float newY = 0)
			=> new Vector3(original.x, newY, original.y);
		/// <summary>
		/// Another name for <see cref="HorizontalPlaneToVector3"/>. I'm testing if it's easier to read
		/// </summary>
		/// <param name="original"></param>
		/// <param name="z">The would-be original Z value, which will be used for the new Y value.</param>
		/// <returns></returns>
		public static Vector3 ToXZY(this Vector2 original, float z = 0)
			=> new Vector3(original.x, z, original.y);
	}
}