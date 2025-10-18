using System;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Attributes;
using Core.Data;
using Core.Debugging;
using Core.Extensions;
using Core.Helpers;
using Core.Movement;
using Core.References;
using Cysharp.Threading.Tasks;
using Movement;
using UnityEngine;
using User.States;

namespace StatesAsync.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Step-Up", fileName = "StepUpBehaviour", order = 1)]
	public class StepUpBehaviour : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[Header("References")]
		[SerializeField] private InterfaceRef<IIdentifier> traversalInputId;
		[SerializeField] private InterfaceRef<IIdentifier> characterId;

		[Header("Optional")]
		[SerializeField, Tooltip("Can be null")] private InterfaceRef<IProcessor<Vector3>> directionPreprocessor;
		[SerializeField, Tooltip("Can be null"), ExposeScriptableObject] private StepUpConfigContainer config;

		[Header("Debug")]
		[SerializeField] private Debugger debugger;
		[ContextMenuItem("Reset Debug Tag", "ResetDebugTag")]
		[SerializeField] private string debugTag;

		private void Reset()
			=> ResetDebugTag();

		private void ResetDebugTag()
			=> debugTag = name;

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
				direction = directionPreprocessor.Ref.Process(direction, character.transform);

			if (ShouldNot() || Cannot(out var destination))
				return false;

			bool hasFloorTracker = character.gameObject.TryGetComponent(out IFloorTracker floorTracker)
			                       && floorTracker is Behaviour;
			if(hasFloorTracker)
			{
				debugger?.Log(debugTag, "Disabling floor tracker in character", this);
				((Behaviour)floorTracker).enabled = false;
			}

			debugger?.Log(debugTag, "Stepping up!", this);
			await stepUp.DoCoroutine(destination, config).ToUniTask(cancellationToken: token);

			if(hasFloorTracker)
			{
				debugger?.Log(debugTag, "Enabling floor tracker in character", this);
				((Behaviour)floorTracker).enabled = true;
			}

			return true;

			bool ShouldNot()
				=> !stepUp.Should(direction, config);

			bool Cannot(out Vector3 destination)
				=> !stepUp.Can(out destination, direction, config);
		}
	}
}
