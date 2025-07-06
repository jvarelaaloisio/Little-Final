using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Views
{
	public class CharacterView : MonoBehaviour, ISetup<ICharacter>
	{
		[SerializeField, TextArea, Tooltip("Editor only field")] private string description;
		protected ICharacter character;

		protected virtual void OnEnable()
		{
			if (character == null)
				enabled = false;
		}

		/// <inheritdoc />
		public virtual void Setup(ICharacter data)
		{
			character = data;
			enabled = true;
		}

		protected bool TryAddPreBehaviour(List<InterfaceRef<IIdentifier>> actionIds,
		                                  Func<IActor, CancellationToken, UniTask> behaviour)
		{
			if (character?.Actor is not IHavePreBehaviours<IActor> preBehaviours)
				return false;
			var result = true;
			foreach (var actionId in actionIds.Where(action => action.HasValue))
				result &= preBehaviours.TryAddPreBehaviour(behaviour, actionId.Ref);
			return result;
		}

		protected void RemovePreBehaviour(List<InterfaceRef<IIdentifier>> actionIds,
		                                  Func<IActor, CancellationToken, UniTask> behaviour)
		{
			if (character?.Actor is not IHavePreBehaviours<IActor> preBehaviours)
				return;
			foreach (var actionId in actionIds.Where(action => action.HasValue))
				preBehaviours.RemovePreBehaviour(behaviour, actionId.Ref);
		}

		protected bool TryAddPostBehaviour(List<InterfaceRef<IIdentifier>> actionIds,
		                                   Func<IActor, CancellationToken, UniTask> behaviour)
		{
			if (character?.Actor is not IHavePostBehaviours<IActor> postBehaviours)
				return false;
			var result = true;
			foreach (var actionId in actionIds.Where(action => action.HasValue))
				result &= postBehaviours.TryAddPostBehaviour(behaviour, actionId.Ref);
			return result;
		}

		protected void RemovePostBehaviour(List<InterfaceRef<IIdentifier>> actionIds,
		                                   Func<IActor, CancellationToken, UniTask> behaviour)
		{
			if (character?.Actor is not IHavePostBehaviours<IActor> postBehaviours)
				return;
			foreach (var actionId in actionIds.Where(action => action.HasValue))
				postBehaviours.RemovePostBehaviour(behaviour, actionId.Ref);
		}
	}
}