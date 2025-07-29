using System;
using System.Threading;
using Core.Helpers;
using Cysharp.Threading.Tasks;

namespace Core.Acting
{
	public interface IActor
	{
		/// <summary>
		/// Data used by the actor.
		/// </summary>
		object Data { get; set; }

		/// <summary>
		/// Type for the data that this actor uses.
		/// </summary>
		Type DataType { get; }

		bool TrySetData(object data);

		/// <summary>
		/// Runs pre-behaviours -> Runs given behaviour -> Runs post-behaviours
		/// </summary>
		/// <param name="behaviour">The action task.</param>
		/// <param name="token"></param>
		/// <param name="actionId">Used to determine which pre- and post-behaviours should run. Default is <see cref="Wildcard"/>.</param>
		UniTask Act(Func<IActor, CancellationToken, UniTask<bool>> behaviour,
		            CancellationToken token,
		            IIdentifier actionId = null);

		/// <summary>
		/// Runs pre-behaviours -> Runs given behaviour -> Runs post-behaviours
		/// </summary>
		/// <param name="behaviour">The action task.</param>
		/// <param name="actionData"></param>
		/// <param name="token"></param>
		/// <param name="actionId">Used to determine which pre- and post-behaviours should run. Default is <see cref="Wildcard"/>.</param>
		UniTask Act<TActionData>(Func<TActionData, IIdentifier, CancellationToken, UniTask<bool>> behaviour,
								 TActionData actionData,
								 CancellationToken token,
								 IIdentifier actionId = null);

		/// <summary>
		/// Runs pre-behaviours -> Runs given behaviour -> Runs post-behaviours
		/// </summary>
		/// <param name="behaviour">The action task.</param>
		/// <param name="actionData"></param>
		/// <param name="token"></param>
		/// <param name="actionId">Used to determine which pre- and post-behaviours should run. Default is <see cref="Wildcard"/>.</param>
		UniTask Act<TActionData>(Func<TActionData, CancellationToken, UniTask<bool>> behaviour,
								 TActionData actionData,
								 CancellationToken token,
								 IIdentifier actionId = null);
		/// <summary>
		/// Runs pre-behaviours -> Runs given behaviour -> Runs post-behaviours
		/// </summary>
		/// <param name="behaviour">The action task.</param>
		/// <param name="actionData"></param>
		/// <param name="token"></param>
		/// <param name="actionId">Used to determine which pre- and post-behaviours should run. Default is <see cref="Wildcard"/>.</param>
		UniTask Act<TActionData>(Func<TActionData, CancellationToken, UniTask> behaviour,
								 TActionData actionData,
								 CancellationToken token,
								 IIdentifier actionId = null);
	}

	public interface IActor<TData> : IActor
	{
		new TData Data { get; set; }
	}
}