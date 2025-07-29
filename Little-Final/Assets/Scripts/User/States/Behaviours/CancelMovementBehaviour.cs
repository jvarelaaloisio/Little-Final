using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace User.States.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Cancel Movement", fileName = "CancelMovement", order = 0)]
	public class CancelMovementBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		/// <inheritdoc />
		public UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (actor.Data.TryGetFirst(out ICharacter character))
				character.Movement = MovementData.InvalidRequest;
			else
				Debug.LogError($"{name} <color=grey>({nameof(CancelMovementBehaviour)})</color>: {nameof(character)} not found!");
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.CompletedTask;

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.FromResult(false);
	}
}