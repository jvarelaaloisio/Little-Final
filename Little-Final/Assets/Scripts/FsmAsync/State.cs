using System;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;

namespace FsmAsync
{
    /// <summary>
    /// State used by the Finite State Machine (FSM) Class
    /// </summary>
    /// <typeparam name="TKey">The key Type to access the different states</typeparam>
    public class State
    {
	    public State(string name)
		    => Name = name;

	    /// <summary>
	    /// Called once when the FSM enters the State
	    /// </summary>
	    public List<Func<State, UniTask>> OnAwake { get; } = new();

	    /// <summary>
	    /// Called once when the FSM exits the State
	    /// </summary>
	    public List<Func<State, UniTask>> OnSleep { get; } = new();


	    public string Name { get; }

	    /// <summary>
	    /// Method called once when entering this state and after exiting the last one.
	    /// <remarks>Always call base method so the corresponding event is raised</remarks>
	    /// </summary>
	    public virtual async UniTask Awake()
	    {
		    foreach (var task in OnAwake)
			    await task(this);
	    }

	    /// <summary>
		/// Method called once when exiting this state and before entering another.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		public virtual async UniTask Sleep()
	    {
		    foreach (var task in OnSleep)
			    await task(this);
	    }

	    public static implicit operator bool(State state) => state != null;
    }
}