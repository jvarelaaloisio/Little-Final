using System;
using System.Collections;
using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace User.States
{
	[CreateAssetMenu(menuName = "States/Character/Jump", fileName = "Jump", order = 0)]
	[Serializable]
	public class Jump : CharacterState
	{
		[SerializeField] private float force;

		public override UniTask Enter(Hashtable transitionData, CancellationToken token)
		{
			Character.Jump(force);
			return base.Enter(transitionData, token);
		}
	}
}