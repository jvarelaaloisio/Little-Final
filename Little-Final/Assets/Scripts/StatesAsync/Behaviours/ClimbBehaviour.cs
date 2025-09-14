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
using User.States;

namespace StatesAsync.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Climb", fileName = "ClimbBehaviour", order = 0)]
	public class ClimbBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[SerializeField] private float positioningDuration = 0.18f;
		[SerializeField] private float climbingPositionOffset = 0.2f;
		[SerializeField] private float rotationResetDuration = 0.18f;

		[Header("Debug")]
		[SerializeField] private bool drawDebugLines;
		[SerializeField] private InterfaceRef<IIdentifier> climbRaycastHitId;

		private readonly Dictionary<IActor, CancellationTokenSource> _cancellationTokenSourcesByActor = new();

		/// <inheritdoc />
		public async UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (_cancellationTokenSourcesByActor.Remove(actor, out var tokenSource))
			{
				tokenSource.Cancel();
				tokenSource.Dispose();
			}

			tokenSource = new CancellationTokenSource();
			_cancellationTokenSourcesByActor.Add(actor, tokenSource);

			if (!actor.Data.TryGetFirst(out Transform transform))
			{
				this.LogError("Couldn't get transform from actor's data!");
				return;
			}
			if (!actor.Data.TryGetFirst(out IPhysicsCharacter character))
			{
				this.LogError("Couldn't get character from actor's data!");
				return;
			}

			character.Body.isKinematic = true;

			if (!actor.Data.TryGet(climbRaycastHitId.Ref, out RaycastHit hit))
			{
				this.LogError("Couldn't get RaycastHit from actor's data!");
				return;
			}

			var targetPosition = hit.point + hit.normal * climbingPositionOffset;

			var targetRotation = Quaternion.FromToRotation(Vector3.forward, -hit.normal);
			targetRotation = Quaternion.LookRotation(-hit.normal, Vector3.up);
			if (drawDebugLines)
			{
				Debug.DrawRay(hit.point, hit.normal, Color.red, 10f);
				Debug.DrawRay(hit.point, -hit.normal, Color.green, 10f);
				Debug.DrawRay(hit.point, targetRotation.normalized.eulerAngles, Color.blue, 10f);
			}
			await GetInPosition(transform, targetPosition, targetRotation, token);
		}

		private async UniTask GetInPosition(Transform transform,
		                                    Vector3 position,
		                                    Quaternion rotation,
		                                    CancellationToken token)
		{
			var originPosition = transform.position;
			var originRotation = transform.rotation;
			float start = Time.time;
			float now = 0;
			do
			{
				now = Time.time;
				float lerp = (now - start) / positioningDuration;
				transform.position = Vector3.Lerp(originPosition, position, lerp);
				transform.rotation = Quaternion.Slerp(originRotation, rotation, lerp);
				await UniTask.NextFrame(token);
			} while (now < start + positioningDuration && !token.IsCancellationRequested);
		}

		/// <inheritdoc />
		public async UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!actor.Data.TryGetFirst(out Transform transform))
			{
				this.LogError("Couldn't get transform from actor's data!");
				return;
			}

			if (actor.Data.TryGetFirst(out IPhysicsCharacter character))
				character.Body.isKinematic = false;
			else
				this.LogError("Couldn't get character from actor's data!");

			var originRotation = transform.rotation;
			var rotation = GetHorizontalForward();
			float start = Time.time;
			float now = 0;
			do
			{
				now = Time.time;
				float lerp = (now - start) / rotationResetDuration;
				transform.rotation = Quaternion.Slerp(originRotation, rotation, lerp);
				await UniTask.NextFrame(token);
			} while (now < start + rotationResetDuration && !token.IsCancellationRequested);

			Quaternion GetHorizontalForward()
			{
				Vector3 forward = transform.TransformDirection(Vector3.forward);
				forward.y = 0;
				var quaternion = forward.sqrMagnitude < 1e-6f
					                 ? Quaternion.identity
					                 : Quaternion.LookRotation(forward.normalized, Vector3.up);
				return quaternion;
			}
		}

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			return UniTask.FromResult(false);
		}
	}
}