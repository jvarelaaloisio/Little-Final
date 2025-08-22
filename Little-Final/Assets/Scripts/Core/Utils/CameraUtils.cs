using System;
using UnityEngine;

namespace Core.Utils
{
	[Obsolete("Remove if not used by 31/09/2025")]
	public static class CameraUtils
	{
		[Obsolete("From what I tested, this is exactly the same as Transform.TransformDirection and ignoring Y")]
		public static Vector3 GetCameraBasedDirection(Transform cameraTransform, Vector2 direction2d)
		{
			var forward = cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			forward.Normalize();
			var right = cameraTransform.TransformDirection(Vector3.right);
			right.y = 0;
			right.Normalize();
			return direction2d.x * right + direction2d.y * forward;
		}
		[Obsolete("From what I tested, this is exactly the same as Transform.TransformDirection and ignoring Y")]
		public static Vector3 GetCameraBasedDirection(Transform cameraTransform, Vector3 direction)
		{
			var forward = cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			forward.Normalize();
			var right = cameraTransform.TransformDirection(Vector3.right);
			right.y = 0;
			right.Normalize();
			return direction.x * right + direction.z * forward;
		}
	}
}
