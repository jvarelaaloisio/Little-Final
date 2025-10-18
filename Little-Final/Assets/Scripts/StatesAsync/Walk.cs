using System;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Gameplay;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using Movement;
using UnityEngine;

namespace User.States
{
	[Obsolete("I think this state is no longer necessary, we can just customize StateSo with behaviours")]
	[CreateAssetMenu(menuName = "States/Character/Walk", fileName = "Walk", order = 0)]
	[Serializable]
	public class Walk : StateSo
	{
		[Obsolete]
		[SerializeField] private InterfaceRef<IDataProviderAsync<IInputReader>> inputReaderProvider;
		
		[SerializeField] [Range(0, 25, .25f)]
		private float acceleration = 20;

		[SerializeField] [Range(0, 100, step: .25f)]
		private float goalSpeed = 2;

		[SerializeField] [Range(0, 100, step: .5f)]
		private float turnSpeed;

		[SerializeField] [Range(0, 90, step: 1)]
		private float minSafeAngle;

		[SerializeField] private LayerMask floor;
		[SerializeField] private StepUpConfigContainer stepUpConfig;
		[SerializeField] private IdContainer lastInputId;
		[SerializeField] private InterfaceRef<IDataProviderAsync<Camera>> cameraProvider;
		private CancellationTokenSource _sleepCts;
		private Transform _cameraTransform;

		public override async UniTask Enter(IActor<ReverseIndexStore> target, CancellationToken token)
		{
			if (!target.Data.TryGetFirst(out ICharacter character))
			{
				Debug.LogError($"{name}: {nameof(character)} is null!");
				return;
			}

			if (cameraProvider.Ref == null)
			{
				Debug.LogError($"{name}: {nameof(cameraProvider)} is null!");
				return;
			}
			var camera = await cameraProvider.Ref.GetValueAsync(token);
			_cameraTransform = camera.transform;

			character.Movement = new MovementData(character.Movement.direction, goalSpeed, acceleration);

			_sleepCts?.Dispose();
			_sleepCts = new CancellationTokenSource();

			await base.Enter(target, token);
		}


		public override UniTask Exit(IActor<ReverseIndexStore> target, CancellationToken token)
		{
			if (!_sleepCts?.IsCancellationRequested ?? false)
				_sleepCts?.Cancel();
			_sleepCts?.Dispose();
			return base.Exit(target, token);
		}
	}
}