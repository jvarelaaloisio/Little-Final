using System;
using System.Collections;
using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace User.States
{
	[Serializable]
	public class Jump : UserState
	{
		[SerializeField] private float force;
		public override UniTask Awake(Hashtable transitionData, CancellationToken token)
		{
			Character.Jump(force);
			return base.Awake(transitionData, token);
		}
	}
}