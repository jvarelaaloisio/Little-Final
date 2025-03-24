using System;
using System.Threading;
using System.Threading.Tasks;

namespace Core.Acting
{
	/// <summary>
	/// An interface that allows for id based preBehaviours to be added and removed. 
	/// </summary>
	/// <typeparam name="TTarget">The user that runs the behaviours</typeparam>
	public interface IHavePreBehaviours<out TTarget>
	{
		public const string Wildcard = "";
		bool TryAddPreBehaviour(Func<TTarget, CancellationToken, Task> behaviour, string actionId = Wildcard);
		void RemovePreBehaviour(Func<TTarget, CancellationToken, Task> behaviour, string actionId = Wildcard);
	}
}