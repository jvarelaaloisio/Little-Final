using System;
using System.Collections.Generic;
using System.Threading;
using Core.FSM;
using Cysharp.Threading.Tasks;

namespace FsmAsync
{
	public interface ITransition<TTarget, out TId>
	{
		TId Id { get; }
		IState<TTarget> From { get; }
		IState<TTarget> To { get; }
		List<Func<(IState<TTarget> from, IState<TTarget> to), UniTask>> OnTransition { get; }
		UniTask Do(TTarget data, bool shouldLogTransition, CancellationToken token);
		UniTask Do(TTarget data, CancellationToken token);
	}
}