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
	public class ParticlesView : CharacterView
	{
		[SerializeField] private ParticleSystem particles;
		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToPlay = new();
		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToStop = new();

		/// <inheritdoc />
		public override void Setup(ICharacter data)
		{
			base.Setup(data);
			if (!particles)
				Debug.LogWarning($"{name} <color=grey>({nameof(ParticlesView)})</color>: {nameof(particles)} not set!");
			
			TryAddPreBehaviour(actionIdsToStop, StopParticles);
			TryAddPostBehaviour(actionIdsToPlay, PlayParticles);
		}

		private void OnDisable()
		{
			RemovePreBehaviour(actionIdsToStop, StopParticles);
			RemovePostBehaviour(actionIdsToPlay, PlayParticles);
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
