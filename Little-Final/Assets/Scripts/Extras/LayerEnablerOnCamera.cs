using System;
using Core.Debugging;
using UnityEngine;

namespace Extras
{
	public class LayerEnablerOnCamera : MonoBehaviour
	{
		[SerializeField]
		private DebuggerSafeContainer debugger;

		[SerializeField]
		private LayerMask cullingMaskOverride;
		[Serializable]
		private struct DebuggerSafeContainer
		{
			[SerializeField]
			private Debugger debugger;

			public Debugger Value
			{
				get
				{
					if (!debugger)
						Debug.LogError("Debugger is null");

					return debugger;
				}
			}
		}
		
		private void Start()
		{
			Camera.main.cullingMask = cullingMaskOverride;
			debugger.Value.Log("Debugs", "camera culling mask overwritten", this);
		}
	}
}