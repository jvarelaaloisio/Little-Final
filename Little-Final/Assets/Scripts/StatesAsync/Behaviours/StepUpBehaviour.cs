using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.Helpers;
using Core.Movement;
using Core.References;
using Cysharp.Threading.Tasks;
using Movement;
using UnityEngine;

namespace User.States.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Step-Up", fileName = "StepUpBehaviour", order = 0)]
	public class StepUpBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[Header("References")]
		[SerializeField] private InterfaceRef<IIdentifier> traversalInputId;
		[SerializeField] private InterfaceRef<IIdentifier> characterId;

		[Header("Optional")]
		[SerializeField, Tooltip("Can be null")] private InterfaceRef<IProcessor<Vector3>> directionPreprocessor;
		[SerializeField, Tooltip("Can be null")] private StepUpConfigContainer config;
		/// <inheritdoc />
		public UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.CompletedTask;

		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.CompletedTask;

		/// <inheritdoc />
		public async UniTask<bool> TryConsumeTick(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (!actor.Data.TryGet(characterId.Ref, out IPhysicsCharacter character))
			{
				this.LogError("Couldn't get character from actor's data!");
				return false;
			}

			if (!character.gameObject.TryGetComponent(out IStepUp stepUp))
			{
				this.LogWarning("Step-Up component not found!");
				return false;
			}

			if (actor.Data[typeof(Vector3), traversalInputId.Ref] is not Vector3 direction)
			{
				this.LogError("Direction is not Vector3!");
				return false;
			}

			if (directionPreprocessor.HasValue)
				direction = directionPreprocessor.Ref.Process(direction);

			if (!stepUp.Should(direction)
			    || !stepUp.Can(out var destination, direction, config))
				return false;
			await stepUp.DoCoroutine(destination, config).ToUniTask(cancellationToken: token);
			return true;
		}
	}
}
