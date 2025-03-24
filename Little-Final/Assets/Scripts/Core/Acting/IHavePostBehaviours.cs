using System;
using System.Threading;
using System.Threading.Tasks;

namespace Core.Acting
{
	/// <summary>
	/// An interface that allows for id based postBehaviours to be added and removed. 
	/// </summary>
	/// <typeparam name="TTarget">The user that runs the behaviours</typeparam>
	public interface IHavePostBehaviours<out TTarget>
	{
		public const string Wildcard = "";
		bool TryAddPostBehaviour(Func<TTarget, CancellationToken, Task> behaviour, string actionId = Wildcard);
		void RemovePostBehaviour(Func<TTarget, CancellationToken, Task> behaviour, string actionId = Wildcard);
	}
}