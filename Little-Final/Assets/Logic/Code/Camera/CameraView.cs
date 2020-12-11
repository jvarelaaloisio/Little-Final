using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;

public class CameraView : MonoBehaviour, ILateUpdateable
{
	Player_Body player_Body;
	ActionOverTime distortAction,
					unDistortAction;
	private float originalFov,
					lastFov;
	CinemachineFreeLook cinemachineFreeLook;
	//void Start()
	//{
	//	cinemachineFreeLook = FindObjectOfType<CinemachineFreeLook>();
	//	FindObjectOfType<UpdateManager>().SubscribeLate(this);
	//	player_Body = FindObjectOfType<Player_Body>();

	//	distortAction = new ActionOverTime(CameraProperties.Instance.DistortTime, Distort, true);
	//	unDistortAction = new ActionOverTime(CameraProperties.Instance.DistortTime, UnDistort, true);
	//	originalFov = cinemachineFreeLook.m_Lens.FieldOfView;
	//}
	public void OnLateUpdate()
	{
		Vector3 horizontalVelocity = player_Body.Velocity;
		horizontalVelocity.y = 0;
		if (horizontalVelocity.magnitude > CameraProperties.Instance.MinSpeedToDistort)
		{
			if (!distortAction.IsRunning)
			{
				lastFov = cinemachineFreeLook.m_Lens.FieldOfView;
				unDistortAction.StopAction();
				distortAction.StartAction();
			}
		}
		else
		{
			if (!unDistortAction.IsRunning)
			{
				lastFov = cinemachineFreeLook.m_Lens.FieldOfView;
				distortAction.StopAction();
				unDistortAction.StartAction();
			}
		}
	}
	private void Distort(float bezier)
	{
		cinemachineFreeLook.m_Lens.FieldOfView = Mathf.Lerp(lastFov, CameraProperties.Instance.DistortFov, bezier);
	}
	private void UnDistort(float bezier)
	{
		cinemachineFreeLook.m_Lens.FieldOfView = Mathf.Lerp(lastFov, originalFov, bezier);
	}
}