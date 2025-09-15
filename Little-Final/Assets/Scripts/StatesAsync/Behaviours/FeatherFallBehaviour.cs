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

namespace User.States.Behaviours
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
				this.LogError("Couldn't get character from actor's data!");
				return;
			}
			physicsCharacter.Body.useGravity = false;
			var fakeGravity = Physics.gravity * gravityMultiplier;
			if (!physicsCharacter.TryAddContinuousForce(fakeGravity))
				this.LogError("Couldn't add continuous force to actor's data!");
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
				this.LogError("Couldn't get character from actor's data!");
				return UniTask.CompletedTask;
			}
			physicsCharacter.Body.useGravity = true;
			var fakeGravity = Physics.gravity * gravityMultiplier;
			physicsCharacter.RemoveContinuousForce(fakeGravity);
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask<bool> TryConsumeTick(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> new(false);
	}
}