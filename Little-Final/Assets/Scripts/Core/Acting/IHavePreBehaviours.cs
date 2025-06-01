using System;
using System.Threading;
using System.Threading.Tasks;
using Core.Helpers;
using Cysharp.Threading.Tasks;

namespace Core.Acting
{
	/// <summary>
	/// An interface that allows for id based preBehaviours to be added and removed. 
	/// </summary>
	/// <typeparam name="TTarget">The user that runs the behaviours</typeparam>
	public interface IHavePreBehaviours<out TTarget>
	{
		bool TryAddPreBehaviour(Func<TTarget, CancellationToken, UniTask> behaviour, IIdentification actionId = default);
		void RemovePreBehaviour(Func<TTarget, CancellationToken, UniTask> behaviour, IIdentification actionId = default);
	}
}