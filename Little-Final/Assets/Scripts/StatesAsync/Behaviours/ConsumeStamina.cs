using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.Helpers;
using Core.Stamina;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace User.States.Behaviours
{
	[CreateAssetMenu(menuName = "States/Behaviours/Consume Stamina", fileName = "ConsumeStamina", order = 0)]
	public class ConsumeStamina : ScriptableObject, IActorStateBehaviour<ReverseIndexStore>
	{
		[SerializeField] private float delay = 0f;
		[Tooltip("Stamina consumed per second")]
		[Range(0.1f, 25f)]
		[SerializeField] private float consumptionRate = 1f;
		/// <inheritdoc />
		public UniTask Enter(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			if (actor.Data.TryGetFirst(out ICharacter character))
			{
				var consumeSource = new CancellationTokenSource();
				actor.Data.Set(new Id(name, GetHashCode()), consumeSource);
				Consume(character.Stamina, consumeSource.Token).Forget();
			}
			else
				this.LogError($"{nameof(character)} not found!");
			return UniTask.CompletedTask;
		}

		private async UniTaskVoid Consume(IStamina characterStamina, CancellationToken token)
		{
			if (delay > 0)
				await UniTask.WaitForSeconds(delay, cancellationToken: token);
			while (!token.IsCancellationRequested)
			{
				characterStamina.Consume(1);
				await UniTask.WaitForSeconds(1 / consumptionRate, cancellationToken: token);
			}
		}

		/// <inheritdoc />
		public UniTask Exit(IActor<ReverseIndexStore> actor, CancellationToken token)
		{
			var id = new Id(name, GetHashCode());
			if (actor.Data.TryGet(id, out CancellationTokenSource consumeSource))
			{
				consumeSource?.Cancel();
				consumeSource?.Dispose();
				actor.Data.Remove(id);
			}
			else
				this.LogError($"{nameof(CancellationTokenSource)} not found!");
			return UniTask.CompletedTask;
		}

		/// <inheritdoc />
		public UniTask<bool> TryConsumeTick(IActor<ReverseIndexStore> actor, CancellationToken token)
			=> UniTask.FromResult(false);
	}
}
