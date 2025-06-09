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
    public class State : IState
    {
	    [field: SerializeField] public string Name { get; set; }

	    /// <inheritdoc />
	    public ILogger Logger { get; set; }

	    /// <inheritdoc />
	    public List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask>> OnEnter { get; } = new();

	    /// <inheritdoc />
	    public List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; } = new();

	    /// <inheritdoc />
	    public List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask>> OnExit { get; } = new();

	    /// <inheritdoc />
	    public virtual async UniTask Enter(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
	    {
		    foreach (var task in OnEnter)
			    await task(this, data, token);
	    }

	    /// <inheritdoc />
	    public async UniTask<bool> TryHandleInput(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
	    {
		    foreach (var task in OnTryHandleInput)
			    if (await task(this, data, token))
				    return true;

		    return false;
	    }

	    /// <inheritdoc />
		public virtual async UniTask Exit(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
	    {
		    foreach (var task in OnExit)
			    await task(this, data, token);
	    }

	    public static implicit operator bool(State state) => state != null;
    }
}