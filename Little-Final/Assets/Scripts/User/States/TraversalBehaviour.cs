using System;
using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Extensions;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using UnityEngine;

namespace User.States
{
	[CreateAssetMenu(menuName = "States/Behaviour/Traversal", fileName = "TraversalBehaviour", order = 0)]
	public class TraversalBehaviour : ScriptableObject, IActorStateBehaviour<IDictionary<Type, IDictionary<IIdentification, object>>>
	{
		private const float PI = Mathf.PI;
		[SerializeField] private float acceleration = 20f;
		[SerializeField] private float speedGoal = 2f;
		[SerializeField] private InterfaceRef<IIdentification> traversalInputId;
		[SerializeField] private InterfaceRef<IIdentification> characterId;
		[SerializeField] private InterfaceRef<IDataProviderAsync<Camera>> cameraProvider;
		private Transform _cameraTransform;

		/// <inheritdoc />
		public async UniTask Enter(IActor<IDictionary<Type, IDictionary<IIdentification, object>>> actor, CancellationToken token)
		{
			if (cameraProvider.Ref == null)
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: {nameof(cameraProvider)} is null!");
				return;
			}
			var camera = await cameraProvider.Ref.GetValueAsync(token);
			_cameraTransform = camera.transform;
			TryHandleInput(actor, token);
		}

		/// <inheritdoc />
		public UniTask Exit(IActor<IDictionary<Type, IDictionary<IIdentification, object>>> actor, CancellationToken token)
			=> UniTask.CompletedTask;

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<IDictionary<Type, IDictionary<IIdentification, object>>> actor, CancellationToken token)
		{
			if (!actor.Data.TryGetValue(typeof(Vector2), out var dictionary)
			    || !dictionary.TryGetValue(traversalInputId.Ref, out var uncastedDirection)
			    || uncastedDirection is not Vector2 direction)
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get direction from actor's data!");

				return new UniTask<bool>(false);
			}
			
			if (!actor.Data.TryGet(characterId.Ref, out IPhysicsCharacter physicsCharacter))
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get character from actor's data!");
				return new UniTask<bool>(false);
			}

			var direction3D = _cameraTransform.TransformDirection(direction.XYToXZY());
			if (!physicsCharacter.FloorTracker?.HasFloor ?? true)
			{
				Debug.LogWarning($"{name}: {nameof(physicsCharacter.FloorTracker)} is null or doesn't have a floor");
				return new UniTask<bool>(false);
			}

			Vector3 directionProjectedOnFloor = Vector3.ProjectOnPlane(direction3D, physicsCharacter.FloorTracker.CurrentFloorData.normal);

			physicsCharacter.Movement.direction = directionProjectedOnFloor;
			if (!Mathf.Approximately(physicsCharacter.Movement.acceleration, acceleration))
				physicsCharacter.Movement.acceleration = acceleration;
			if (!Mathf.Approximately(physicsCharacter.Movement.goalSpeed, speedGoal))
				physicsCharacter.Movement.goalSpeed = speedGoal;
			
			return new UniTask<bool>(true);
		}
		//
		// private async UniTask FixedUpdate(IPhysicsCharacter character, Vector2 direction, CancellationToken token)
		// {
		// 	while (!token.IsCancellationRequested)
		// 	{
		// 		await UniTask.WaitForFixedUpdate(token);
		//
		// 		var rigidbody = character.rigidbody;
		// 		var currentVelocity = rigidbody.velocity;
		// 		var x = Mathf.Sqrt(currentVelocity.x * currentVelocity.x + currentVelocity.z * currentVelocity.z);
		// 		var force = (2 - 1 / Mathf.Cos(x * PI / (3 * speedGoal))) * acceleration;
		// 		force = Mathf.Max(0, force);
		// 		rigidbody.AddForce(new Vector3(direction.x, 0, direction.y) * force, ForceMode.Force);
		// 	}
		// }
	}
}