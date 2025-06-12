using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Core.Helpers;
using Cysharp.Threading.Tasks;

namespace FsmAsync
{
	public interface ITransition<T>
	{
		IState<T> From { get; }
		IState<T> To { get; }
		List<Func<(IState<T> from, IState<T> to), UniTask>> OnTransition { get; }
		UniTask Do(T data, bool shouldLogTransition, CancellationToken token);
	}
}