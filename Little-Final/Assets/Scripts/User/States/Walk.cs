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
using Player.Movement;
using UnityEngine;

namespace User.States
{
	[CreateAssetMenu(menuName = "States/Character/Walk", fileName = "Walk", order = 0)]
	[Serializable]
	public class Walk : StateSo
	{
		[Obsolete]
		[SerializeField] private InterfaceRef<DataProviderAsync<IInputReader>> inputReaderProvider;
		
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
			
			character.Movement.goalSpeed = goalSpeed;
			character.Movement.acceleration = acceleration;
			//TODO: Remove if no longer needed
			// if (lastInputId
			//     && data.ContainsKey(lastInputId.Get)
			//     && data[lastInputId.Get] is Vector2 lastInput)
			// 	HandleMoveInput(lastInput);
			// else
			// 	Logger?.LogWarning(Name,$"{nameof(data)} doesn't contain the key {lastInputId?.Get}");

			//TODO: Remove all references to inputs in the states
			if (inputReaderProvider.Ref)
			{
				var inputReader = await inputReaderProvider.Ref.GetValueAsync(token);
				inputReader.OnMoveInput += HandleMoveInput;
			}

			_sleepCts?.Dispose();
			_sleepCts = new CancellationTokenSource();

			await base.Enter(target, token);
		}


		public override UniTask Exit(IActor<ReverseIndexStore> target, CancellationToken token)
		{
			if (inputReaderProvider.Ref?.TryGetValue(out var inputReader) ?? false)
				inputReader.OnMoveInput -= HandleMoveInput;
			_sleepCts?.Cancel();
			_sleepCts?.Dispose();
			return base.Exit(target, token);
		}

		[Obsolete("This should be handled outside of the state")]
		private void HandleMoveInput(Vector2 input)
		{
			//TODO: Remove method if no longer needed
			// var direction = _cameraTransform.TransformDirection(input.XYToXZY()).IgnoreY();
			// if (Character == null)
			// {
			// 	Logger.LogError(Name, $"{nameof(Character)} is null!");
			// 	return;
			// }
			//
			// if (!Character.FloorTracker?.HasFloor ?? true)
			// {
			// 	Logger.LogWarning(Name, $"{nameof(Character.FloorTracker)} is null or doesn't have a floor");
			// 	return;
			// }
			// // var floorNormal = 
			// // if (Physics.Raycast(Character.transform.position,
			// // 	    -Character.transform.up,
			// // 	    out var hit,
			// // 	    10,
			// // 	    floor))
			// // {
			// // 	floorNormal = hit.normal;
			// // }
			// Vector3 directionProjectedOnFloor = Vector3.ProjectOnPlane(direction, Character.FloorTracker.CurrentFloorData.normal);
			//
			// Character.Movement.direction = directionProjectedOnFloor;
		}
	}
}