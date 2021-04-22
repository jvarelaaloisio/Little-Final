using UnityEngine;

namespace Core.Extensions
{
	public static class TransformExtensions
	{
		public static void Lerp(
			this Transform subject,
			Vector3 positionA,
			Vector3 positionB,
			Quaternion rotationA,
			Quaternion rotationB,
			Vector3 scaleA,
			Vector3 scaleB,
			float t)
		{
			subject.position
				= Vector3.Lerp(
					positionA,
					positionB,
					t
				);
			subject.rotation
				= Quaternion.Lerp(
					rotationA,
					rotationB,
					t
				);
			subject.localScale
				= Vector3.Lerp(
					scaleA,
					scaleB,
					t
				);
		}
	}
}