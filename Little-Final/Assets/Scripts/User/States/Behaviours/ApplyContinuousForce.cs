using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace User.States.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Apply Continuous Force", fileName = "ApplyContinuousForce", order = 0)]
	public class ApplyContinuousForce : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[SerializeField] private Vector3 force = Vector3.zero;
		[SerializeField] private ForceMode forceMode =  ForceMode.Force;
		[SerializeField] private bool enableLog;

		/// <inheritdoc />
		public UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!actor.Data.TryGetFirst(out IPhysicsCharacter physicsCharacter)
				|| !physicsCharacter.TryAddContinuousForce(force, forceMode))
				this.LogError($"{nameof(physicsCharacter)} not found!");
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (actor.Data.TryGetFirst(out IPhysicsCharacter physicsCharacter))
				physicsCharacter.RemoveContinuousForce(force, forceMode);
			else
				this.LogError($"{nameof(physicsCharacter)} not found!");
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask<bool> TryHandleInput(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.FromResult(false);
	}
}