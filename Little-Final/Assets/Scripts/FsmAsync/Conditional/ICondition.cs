using System;
using System.Threading;
using Cysharp.Threading.Tasks;

namespace FsmAsync.Conditional
{
	public interface ICondition<TTarget, TOutput> : IEquatable<ICondition<TTarget, TOutput>>
	{
		Func<TTarget, CancellationToken, UniTask<bool>> Predicate { get; }
		TOutput Output { get; }
		string Name { get; }
		UniTask<bool> IsMet(TTarget data, CancellationToken token);
		UniTask<bool> IsMet(TTarget data, out TOutput output, CancellationToken token);
		TOutput GetOutput();
	}
}