using System;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
	/// <summary>
	/// State used by the Finite State Machine (FSM) Class
	/// </summary>
	[Serializable]
    public class State<T> : IState<T>
    {
	    [field: SerializeField] public string Name { get; set; }

	    /// <inheritdoc />
	    public List<Func<IState<T>, T, CancellationToken, UniTask>> OnEnter { get; } = new();

	    /// <inheritdoc />
	    public List<Func<IState<T>, T, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; } = new();

	    /// <inheritdoc />
	    public List<Func<IState<T>, T, CancellationToken, UniTask>> OnExit { get; } = new();

	    /// <inheritdoc />
	    public virtual async UniTask Enter(T target, CancellationToken token)
	    {
		    foreach (var task in OnEnter)
			    await task(this, target, token);
	    }

	    /// <inheritdoc />
	    public async UniTask<bool> TryHandleDataChanged(T target, CancellationToken token)
	    {
		    foreach (var task in OnTryHandleInput)
			    if (await task(this, target, token))
				    return true;

		    return false;
	    }

	    /// <inheritdoc />
		public virtual async UniTask Exit(T target, CancellationToken token)
	    {
		    foreach (var task in OnExit)
			    await task(this, target, token);
	    }

	    public static implicit operator bool(State<T> state) => state != null;
    }
}