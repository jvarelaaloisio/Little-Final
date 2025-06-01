using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;

namespace FsmAsync
{
	public interface ITransition
	{
		IState From { get; }
		IState To { get; }
		List<Func<(IState from, IState to), UniTask>> OnTransition { get; }
		UniTask Do(CancellationToken token, Hashtable data = null);
	}
}