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
    /// <typeparam name="TKey">The key Type to access the different states</typeparam>
    [Serializable]
    public class State
    {
	    /// <summary>
	    /// Called once when the FSM enters the State
	    /// </summary>
	    public List<Func<(State state, CancellationToken token), UniTask>> OnAwake { get; } = new();

	    /// <summary>
	    /// Called once when the FSM exits the State
	    /// </summary>
	    public List<Func<(State state, CancellationToken token), UniTask>> OnSleep { get; } = new();

	    [field: SerializeField]public string Name { get; set; }

	    /// <summary>
	    /// Method called once when entering this state and after exiting the last one.
	    /// <remarks>Always call base method so the corresponding event is raised</remarks>
	    /// </summary>
	    //TODO: refactor to UniTask<Hashtable>
	    public virtual async UniTask Awake(Hashtable transitionData, CancellationToken token)
	    {
		    foreach (var task in OnAwake)
			    await task((this, token));
	    }

	    /// <summary>
		/// Method called once when exiting this state and before entering another.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		public virtual async UniTask Sleep(Hashtable transitionData, CancellationToken token)
	    {
		    foreach (var task in OnSleep)
			    await task((this, token));
	    }

	    public static implicit operator bool(State state) => state != null;
    }
}