using System;
using System.Threading;
using System.Threading.Tasks;
using Core.Helpers;
using Cysharp.Threading.Tasks;

namespace Core.Acting
{
	/// <summary>
	/// An interface that allows for id based postBehaviours to be added and removed. 
	/// </summary>
	/// <typeparam name="TTarget">The user that runs the behaviours</typeparam>
	public interface IHavePostBehaviours<out TTarget>
	{
		bool TryAddPostBehaviour(Func<TTarget, CancellationToken, UniTask> behaviour, IIdentification actionId = default);
		void RemovePostBehaviour(Func<TTarget, CancellationToken, UniTask> behaviour, IIdentification actionId = default);
	}
}