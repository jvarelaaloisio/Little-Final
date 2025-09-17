using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.Serialization;
using User.States;

namespace StatesAsync.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Traversal", fileName = "TraversalBehaviour", order = 0)]
	public class TraversalBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[SerializeField] private float acceleration = 20f;
		[SerializeField] private float speedGoal = 2f;
		[Tooltip("If the direction vector should follow the angle of the floor where the character is currently on." +
		         "\n(useful for floored behaviour).")]
		[SerializeField] private bool projectDirectionOnFloor;
		[Header("Brake")]
		[SerializeField] private float brakeSpeed = .25f;
		[SerializeField] private float brakeAcceleration = .25f;
		[Tooltip("If the current floor normal should be verified before adding movement." +
		         "\n(useful for floored behaviour).")]
		[SerializeField] private bool validateCurrentFloor;
		[Header("Slopes and walls")]
		[SerializeField] private AnimationCurve decelerationCurveWhenApproachingWall;
		[SerializeField] private float maxSlopeAngle = 45;
		[FormerlySerializedAs("traversalInputId")]
		[Header("References")]
		[SerializeField] private InterfaceRef<IIdentifier> directionId;
		[SerializeField] private InterfaceRef<IIdentifier> characterId;

		[Header("Optional")]
		[SerializeField, Tooltip("Can be null")] private InterfaceRef<IProcessor<Vector3>> directionPreprocessor;

		[Header("Debug")]
		[SerializeField] private bool drawDebugLines;

		/// <inheritdoc />
		public async UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			await TryConsumeTick(actor, token);

			if (!actor.Data.TryGet(characterId.Ref, out IPhysicsCharacter physicsCharacter))
			{
				this.LogError("Couldn't get character from actor's data!");
				return;
			}
			physicsCharacter.Movement = new MovementData(physicsCharacter.Movement.direction, acceleration, speedGoal);
		}

		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.CompletedTask;

		/// <inheritdoc />
		public UniTask<bool> TryConsumeTick(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!actor.Data.TryGet(characterId.Ref, out IPhysicsCharacter character))
			{
				this.LogError("Couldn't get character from actor's data!");
				return new(false);
			}
			if (actor.Data[typeof(Vector3), directionId.Ref] is not Vector3 direction)
			{
				this.LogError("Direction is not Vector3!");
				return new(false);
			}

			if (!(character.FloorTracker?.HasFloor ?? false))
			{
				this.LogWarning($"{nameof(character.FloorTracker)} is null or doesn't have a floor", character.gameObject);
				return new(false);
			}

			var floor = character.FloorTracker.CurrentFloorData;

			if (directionPreprocessor.HasValue)
				direction = directionPreprocessor.Ref.Process(direction);

			var movementDirection = projectDirectionOnFloor
				                        ? Vector3.ProjectOnPlane(direction, floor.normal)
				                        : direction;
			
			if (CharacterWantsToBrake(character, movementDirection))
			{
				character.Movement = new MovementData(-character.Velocity.IgnoreY(), brakeSpeed, brakeAcceleration);
				return UniTask.FromResult(true);
			}

			if (validateCurrentFloor && !IsSlope(floor, maxSlopeAngle))
			{
				character.Movement = MovementData.InvalidRequest;
				return UniTask.FromResult(true);
			}

			if (IsApproachingWall(character.transform.position, direction * 0.35f, out var hit)
			    && !IsSlope(hit, maxSlopeAngle))
			{
				var speed = hit.distance;

				if (drawDebugLines)
					Debug.DrawLine(character.transform.position, hit.point, new Color(1, .4f, 0));
				speed = decelerationCurveWhenApproachingWall.Evaluate(speed / speedGoal);
				character.Movement = speed <= 0
					                     ? MovementData.InvalidRequest
					                     : new MovementData(movementDirection, speed, acceleration);
				return UniTask.FromResult(true);
			}

			if (drawDebugLines)
				Debug.DrawRay(character.transform.position, movementDirection * 0.35f, Color.green);
			character.Movement = new MovementData(movementDirection, speedGoal, acceleration);
			return new(true);

			static bool CharacterWantsToBrake(ICharacter character, Vector3 direction)
				=> Vector3.Dot(direction.normalized, character.Movement.direction) < -.5f;
		}

		private static bool IsSlope(RaycastHit hit, float maxAngle)
		{
			float angle = Vector3.Angle(hit.normal, Vector3.up);
			return angle <= maxAngle;
		}

		private bool IsApproachingWall(Vector3 position, Vector3 direction, out RaycastHit hit)
		{
			return Physics.Raycast(position, direction, out hit, speedGoal);
		}
	}
}