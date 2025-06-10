using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Core.Helpers;
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
	    public ILogger Logger { get; set; }

	    /// <inheritdoc />
	    public List<Func<IState<T>, T, CancellationToken, UniTask>> OnEnter { get; } = new();

	    /// <inheritdoc />
	    public List<Func<IState<T>, T, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; } = new();

	    /// <inheritdoc />
	    public List<Func<IState<T>, T, CancellationToken, UniTask>> OnExit { get; } = new();

	    /// <inheritdoc />
	    public virtual async UniTask Enter(T data, CancellationToken token)
	    {
		    foreach (var task in OnEnter)
			    await task(this, data, token);
	    }

	    /// <inheritdoc />
	    public async UniTask<bool> TryHandleInput(T data, CancellationToken token)
	    {
		    foreach (var task in OnTryHandleInput)
			    if (await task(this, data, token))
				    return true;

		    return false;
	    }

	    /// <inheritdoc />
		public virtual async UniTask Exit(T data, CancellationToken token)
	    {
		    foreach (var task in OnExit)
			    await task(this, data, token);
	    }

	    public static implicit operator bool(State<T> state) => state != null;
    }
}