using System;
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

namespace User.States
{
	[CreateAssetMenu(menuName = "States/Behaviour/Jump", fileName = "JumpBehaviour", order = 0)]
	public class JumpBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[SerializeField] private InterfaceRef<IIdentifier> characterId;
		[SerializeField] private float force = 5.5f;

		/// <inheritdoc />
		public UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			
			if (!actor.Data.TryGet(characterId.Ref, out ICharacter character))
			{
				Debug.LogError($"{name} <color=grey>({nameof(TraversalBehaviour)})</color>: Couldn't get character from actor's data!");
				return new UniTask<bool>(false);
			}
			character.Jump(force);
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.CompletedTask;

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> new(false);
	}
}