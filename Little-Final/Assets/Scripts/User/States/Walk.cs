using System;
using System.Collections;
using System.Threading;
using Core.Helpers;
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

		[SerializeField] private LayerMask floor;
		[SerializeField] private StepUpConfigContainer stepUpConfig;
		[SerializeField] private IdContainer lastInputId;
		public Vector3 _directionProjectedOnFloor;
		private CancellationTokenSource sleepCts;

		public override UniTask Awake(Hashtable data, CancellationToken token)
		{
			if (Character == null)
			{
				Debug.Log($"{nameof(Character)} is null!");
				return UniTask.CompletedTask;
			}
			Character.Movement.goalSpeed = goalSpeed;
			Character.Movement.acceleration = acceleration;
			if (lastInputId
			    && data.ContainsKey(lastInputId.Get)
			    && data[lastInputId.Get] is Vector2 lastInput)
				HandleMoveInput(lastInput);
			else
				Logger?.LogWarning(Name,$"${nameof(data)} doesn't contain the key {lastInputId?.Get}");

			if (InputReader != null)
				InputReader.OnMoveInput += HandleMoveInput;

			sleepCts?.Dispose();
			sleepCts = new CancellationTokenSource();
			Update(sleepCts.Token).Forget();

			return base.Awake(data, token);
		}

		private async UniTaskVoid Update(CancellationToken token)
		{
			while (!token.IsCancellationRequested)
			{
				Debug.Log("update");
				await UniTask.Yield();
			}
		}

		public override UniTask Sleep(Hashtable data, CancellationToken token)
		{
			if (InputReader != null)
				InputReader.OnMoveInput -= HandleMoveInput;
			Update(sleepCts.Token).Forget();
			sleepCts?.Cancel();
			sleepCts?.Dispose();
			return base.Sleep(data, token);
		}

		private void HandleMoveInput(Vector2 input)
		{
			//TODO: Replace with ISetup
			var cameraTransform = Camera.main.transform;
			var forward = cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			var right = cameraTransform.TransformDirection(Vector3.right);
			Vector3 direction = input.x * right + input.y * forward;

			if (Character == null)
			{
				Logger.LogError(Name, $"{nameof(Character)} is null!");
				return;
			}

			var floorNormal = Vector3.up;
			if (Physics.Raycast(Character.transform.position,
				    -Character.transform.up,
				    out var hit,
				    10,
				    floor))
			{
				floorNormal = hit.normal;
			}
			Vector3 directionProjectedOnFloor = Vector3.ProjectOnPlane(direction, floorNormal);
			_directionProjectedOnFloor = directionProjectedOnFloor;

			Character.Movement.direction = directionProjectedOnFloor;
		}
	}
}