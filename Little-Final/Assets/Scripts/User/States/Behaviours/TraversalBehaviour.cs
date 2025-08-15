using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
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
		[Header("Brake")]
		[SerializeField] private float brakeSpeed = .25f;
		[SerializeField] private float brakeAcceleration = .25f;
		[Header("Slopes and walls")]
		[SerializeField] private AnimationCurve decelerationCurveWhenApproachingWall;
		[SerializeField] private float maxSlopeAngle = 45;
		[Header("References")]
		[SerializeField] private InterfaceRef<IIdentifier> traversalInputId;
		[SerializeField] private InterfaceRef<IIdentifier> characterId;
		[SerializeField] private InterfaceRef<IDataProviderAsync<Camera>> cameraProvider;

		private Transform _cameraTransform;
		private readonly Dictionary<IActor, CancellationTokenSource> _cancellationTokenSourcesByActor = new ();

		/// <inheritdoc />
		public async UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!cameraProvider.HasValue)
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
			physicsCharacter.Movement = new MovementData(physicsCharacter.Movement.direction, acceleration, speedGoal);
		}

		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!_cancellationTokenSourcesByActor.Remove(actor, out var tokenSource))
				return UniTask.CompletedTask;

			tokenSource.Cancel();
			tokenSource.Dispose();
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!actor.Data.TryGet(characterId.Ref, out IPhysicsCharacter character))
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get character from actor's data!");
				return new(false);
			}
			if (actor.Data[typeof(Vector2), traversalInputId.Ref] is not Vector2 direction2d)
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Direction is not Vector2!");
				return new(false);
			}

			if (!(character.FloorTracker?.HasFloor ?? false))
			{
				this.LogWarning($"{nameof(character.FloorTracker)} is null or doesn't have a floor", character.gameObject);
				return new(false);
			}

			var floor = character.FloorTracker.CurrentFloorData;

			var forward = _cameraTransform.TransformDirection(Vector3.forward);
			forward.y = 0;
			forward.Normalize();
			var right = _cameraTransform.TransformDirection(Vector3.right);
			right.y = 0;
			right.Normalize();
			Vector3 cameraBasedDirection = direction2d.x * right + direction2d.y * forward;
			var directionProjectedOnFloor = Vector3.ProjectOnPlane(cameraBasedDirection, floor.normal);
			
			if (CharacterWantsToBrake(character, directionProjectedOnFloor))
			{
				character.Movement = new MovementData(-character.Velocity.IgnoreY(), brakeSpeed, brakeAcceleration);
				return UniTask.FromResult(true);
			}

			var direction = cameraBasedDirection.IgnoreY();
			if (IsApproachingWall(character.transform.position, direction, out var hit)
			    && IsNotSlope(hit, maxSlopeAngle))
			{
				var speed = hit.distance;

				Debug.DrawLine(character.transform.position, hit.point, new Color(1, .4f, 0));
				character.Movement = new MovementData(directionProjectedOnFloor, decelerationCurveWhenApproachingWall.Evaluate(speed / speedGoal), acceleration);
				return UniTask.FromResult(true);
			}

			Debug.DrawRay(character.transform.position, directionProjectedOnFloor, Color.green);
			character.Movement = new MovementData(directionProjectedOnFloor, speedGoal, acceleration);
			return new(true);

			static bool CharacterWantsToBrake(ICharacter character, Vector3 direction)
				=> Vector3.Dot(direction.normalized, character.Movement.direction) < -.5f;
		}

		private static bool IsNotSlope(RaycastHit hit, float maxAngle)
		{
			float angle = Vector3.Angle(hit.normal, Vector3.up);
			return angle > maxAngle;
		}

		private bool IsApproachingWall(Vector3 position, Vector3 direction, out RaycastHit hit)
		{
			return Physics.Raycast(position, direction, out hit, speedGoal);
		}
	}
}