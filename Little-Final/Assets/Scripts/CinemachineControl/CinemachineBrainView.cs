using System;
using System.Collections.Generic;
using Cinemachine;
using Events.Channels;
using UnityEngine;

namespace CinemachineControl
{
	public class CinemachineBrainView : MonoBehaviour
	{
		[SerializeField]
		private CinemachineBrain cinemachineBrain;

		[SerializeField]
		private List<VoidChannelSo> triggerLateUpdateChannels;
		
		[SerializeField]
		private List<VoidChannelSo> triggerFixedUpdateChannels;

		private void OnValidate()
		{
			if (!cinemachineBrain) TryGetComponent(out cinemachineBrain);
		}

		[ContextMenu("Awake")]
		private void Awake()
		{
			triggerLateUpdateChannels.ForEach(c => c.Subscribe(SetLateUpdateMethod));
			triggerFixedUpdateChannels.ForEach(c => c.Subscribe(SetFixedUpdateMethod));
		}

		private void SetFixedUpdateMethod()
		{
			cinemachineBrain.m_UpdateMethod = CinemachineBrain.UpdateMethod.FixedUpdate;
		}

		private void SetLateUpdateMethod()
		{
			cinemachineBrain.m_UpdateMethod = CinemachineBrain.UpdateMethod.LateUpdate;
		}
	}
}
