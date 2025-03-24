using System;
using System.Threading;
using System.Threading.Tasks;

namespace Core.Acting
{
	public interface IActor
	{
		/// <summary>
		/// Value used as common action id to store tasks in <see cref="PreBehavioursByAction"/> and <see cref="PostBehavioursByAction"/>.
		/// Any behaviour stored in Wildcard will be run once anytime an action is done.
		/// </summary>
		public const string Wildcard = "";
		/// <summary>
		/// Data used by the actor.
		/// </summary>
		object Data { get; }

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
		Task Act(Func<IActor, CancellationToken, Task> behaviour,
			CancellationToken token,
			string actionId = Wildcard);
	}

	public interface IActor<TData> : IActor
	{
		new TData Data { get; }
		void SetData(TData data);
	}
}