using System;
using Cinemachine;
using UnityEngine;

namespace CinemachineControl
{
	public class CopyCameraState : MonoBehaviour
	{
		[SerializeField]
		private Transform camera;

		[SerializeField]
		private CinemachineFreeLook freeLook;

		[ContextMenu("Copy Virtual Cam position To FreeLook")]
		private void CopyVirtualToFreeLook()
		{
			freeLook.ForceCameraPosition(camera.position, camera.rotation);
		}

		public void ResetFreeLookCamera(ICinemachineCamera toCam, ICinemachineCamera fromCam)
		{
			if (ReferenceEquals(toCam, freeLook))
			{
				CopyVirtualToFreeLook();
			}
		}
	}
}