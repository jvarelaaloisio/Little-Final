using System;
using System.Collections;
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
    public class State : IState
    {
	    [field: SerializeField] public string Name { get; set; }

	    /// <inheritdoc />
	    public ILogger Logger { get; set; }

	    /// <inheritdoc />
	    public List<Func<(IState state, CancellationToken token), UniTask>> OnEnter { get; } = new();

	    /// <inheritdoc />
	    public List<Func<(IState state, CancellationToken token), UniTask>> OnExit { get; } = new();

	    /// <inheritdoc />
	    public virtual async UniTask Enter(Hashtable transitionData, CancellationToken token)
	    {
		    foreach (var task in OnEnter)
			    await task((this, token));
	    }

	    /// <inheritdoc />
		public virtual async UniTask Exit(Hashtable transitionData, CancellationToken token)
	    {
		    foreach (var task in OnExit)
			    await task((this, token));
	    }

	    public static implicit operator bool(State state) => state != null;
    }
}