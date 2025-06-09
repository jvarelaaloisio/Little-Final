using System;
using System.Collections;
using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace User.States
{
	[CreateAssetMenu(menuName = "States/Character/Jump", fileName = "Jump", order = 0)]
	[Serializable]
	public class Jump : StateSo
	{
		[SerializeField] private float force;

		public UniTask Enter(Hashtable transitionData, CancellationToken token)
		{
			Character.Jump(force);
			return UniTask.CompletedTask;
		}
	}
}