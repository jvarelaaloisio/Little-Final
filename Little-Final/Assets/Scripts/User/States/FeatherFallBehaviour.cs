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
using UnityEngine.Serialization;

namespace User.States
{
	[CreateAssetMenu(menuName = "States/Behaviours/Feather Fall", fileName = "FeatherFallBehaviour", order = 0)]
	public class FeatherFallBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[SerializeField] private float gravityMultiplier = 0.15f;
		[SerializeField] private InterfaceRef<IIdentifier> physicsCharacterId;
		private readonly Dictionary<IActor, CancellationTokenSource> _cancellationTokenSourcesByActor = new ();

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
			
			if (!actor.Data.TryGet(physicsCharacterId.Ref, out IPhysicsCharacter physicsCharacter))
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get character from actor's data!");
				return;
			}
			physicsCharacter.rigidbody.useGravity = false;
			   if (!physicsCharacter.TryAddContinuousForce(Physics.gravity * gravityMultiplier))
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't add continuous force to actor's data!");
		}
		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (_cancellationTokenSourcesByActor.Remove(actor, out var tokenSource))
			{
				tokenSource.Cancel();
				tokenSource.Dispose();
			}
			if (!actor.Data.TryGet(physicsCharacterId.Ref, out IPhysicsCharacter physicsCharacter))
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get character from actor's data!");
				return UniTask.CompletedTask;
			}
			physicsCharacter.rigidbody.useGravity = true;
			physicsCharacter.RemoveContinuousForce(Physics.gravity * gravityMultiplier);
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> new(false);
	}
}