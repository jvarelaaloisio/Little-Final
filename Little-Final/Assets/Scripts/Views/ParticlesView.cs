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
	public class ParticlesView : MonoBehaviour
	{
		[SerializeField] private string description;
		[SerializeField] private InterfaceRef<ICharacter> character;
		[SerializeField] private ParticleSystem particles;
		[SerializeField] private List<InterfaceRef<IIdentification>> actionIdsToPlay = new();
		[SerializeField] private List<InterfaceRef<IIdentification>> actionIdsToStop = new();

		private void Reset()
		{
			character.Ref = GetComponent<ICharacter>();
		}

		private async void OnEnable()
		{
			var watchdog = 1000;
			while (!character.HasValue
			       && watchdog-- > 0)
			{
				await UniTask.Yield(destroyCancellationToken);
				character.Ref = GetComponent<ICharacter>();
			}
			if (!character.HasValue)
			{
				Debug.LogError($"{name} <color=grey>({nameof(ParticlesView)})</color>: Cannot find {nameof(ICharacter)}");
				enabled = false;
				return;
			}

			if (!particles)
				Debug.LogWarning($"{name} <color=grey>({nameof(ParticlesView)})</color>: {nameof(particles)} not set!");
			
			if (character.Ref.Actor is IHavePreBehaviours<IActor> preBehaviours)
				foreach (var actionId in actionIdsToStop.Where(action => action.HasValue))
					preBehaviours.TryAddPreBehaviour(StopParticles, actionId.Ref);
			
			if (character.Ref.Actor is IHavePostBehaviours<IActor> postBehaviours)
				foreach (var actionId in actionIdsToPlay.Where(action => action.HasValue))
					postBehaviours.TryAddPostBehaviour(PlayParticles, actionId.Ref);
		}

		private UniTask PlayParticles(IActor actor, CancellationToken token)
		{
			particles.Play();
			return UniTask.CompletedTask;
		}

		private UniTask StopParticles(IActor arg1, CancellationToken arg2)
		{
			particles.Stop();
			return UniTask.CompletedTask;
		}
	}
}
