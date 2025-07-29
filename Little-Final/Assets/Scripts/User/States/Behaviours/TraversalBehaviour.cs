using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using UnityEngine;

namespace User.States.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Traversal", fileName = "TraversalBehaviour", order = 0)]
	public class TraversalBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[SerializeField] private float acceleration = 20f;
		[SerializeField] private float speedGoal = 2f;
		[SerializeField] private InterfaceRef<IIdentifier> traversalInputId;
		[SerializeField] private InterfaceRef<IIdentifier> characterId;
		[SerializeField] private InterfaceRef<IDataProviderAsync<Camera>> cameraProvider;
		private Transform _cameraTransform;
		private readonly Dictionary<IActor, CancellationTokenSource> _cancellationTokenSourcesByActor = new ();

		/// <inheritdoc />
		public async UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (cameraProvider.Ref == null)
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: {nameof(cameraProvider)} is null!");
				return;
			}
			var camera = await cameraProvider.Ref.GetValueAsync(token);
			_cameraTransform = camera.transform;
			if (_cancellationTokenSourcesByActor.Remove(actor, out var tokenSource))
			{
				tokenSource.Cancel();
				tokenSource.Dispose();
			}
			tokenSource = new CancellationTokenSource();
			_cancellationTokenSourcesByActor.Add(actor, tokenSource);
			await TryHandleInput(actor, token);

			if (!actor.Data.TryGet(characterId.Ref, out IPhysicsCharacter physicsCharacter))
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get character from actor's data!");
				return;
			}
			physicsCharacter.Movement.acceleration = acceleration;
			physicsCharacter.Movement.goalSpeed = speedGoal;
		}
		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (_cancellationTokenSourcesByActor.Remove(actor, out var tokenSource))
			{
				tokenSource.Cancel();
				tokenSource.Dispose();
			}
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!actor.Data.TryGet(characterId.Ref, out IPhysicsCharacter physicsCharacter))
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get character from actor's data!");
				return new(false);
			}
			if (actor.Data[typeof(Vector2), traversalInputId.Ref] is not Vector2 direction)
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Direction is not Vector2!");
				return new(false);
			}

			if (!(physicsCharacter.FloorTracker?.HasFloor ?? false))
			{
				Debug.LogWarning($"{name}: {nameof(physicsCharacter.FloorTracker)} is null or doesn't have a floor");
				return new(false);
			}

			var floorNormal = physicsCharacter.FloorTracker.CurrentFloorData.normal;

			var forward = _cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			forward.Normalize();
			var right = _cameraTransform.TransformDirection(Vector3.right);
			right.y = 0;
			right.Normalize();
			Vector3 cameraBasedDirection = direction.x * right + direction.y * forward;
			var directionProjectedOnFloor = Vector3.ProjectOnPlane(cameraBasedDirection, floorNormal);
			physicsCharacter.Movement.direction = directionProjectedOnFloor;
			return new(true);
		}
	}
}