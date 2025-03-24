using System;
using Cysharp.Threading.Tasks;
using Player.Movement;
using UnityEngine;

namespace User.States
{
	[Serializable]
	public class Walk : UserState
	{
		[SerializeField] [Range(0, 25, .25f)]
		private float acceleration = 20;

		[SerializeField] [Range(0, 100, step: .25f)]
		private float goalSpeed = 2;

		[SerializeField] [Range(0, 100, step: .5f)]
		private float turnSpeed;

		[SerializeField] [Range(0, 90, step: 1)]
		private float minSafeAngle;

		[SerializeField] private StepUpConfigContainer stepUpConfig;

		public override UniTask Awake()
		{
			Character.Movement.goalSpeed = goalSpeed;
			Character.Movement.acceleration = acceleration;
			return base.Awake();
		}
	}
}