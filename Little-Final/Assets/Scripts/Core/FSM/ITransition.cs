using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Core.Helpers;
using Cysharp.Threading.Tasks;

namespace FsmAsync
{
	public interface ITransition
	{
		IState From { get; }
		IState To { get; }
		List<Func<(IState from, IState to), UniTask>> OnTransition { get; }
		UniTask Do(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token);
	}
}