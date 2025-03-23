using System;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
    /// <summary>
    /// Finite state machine with async implementation of methods
    /// </summary>
    /// <typeparam name="TKey">The key Type to access the different states</typeparam>
    public class FiniteStateMachine<TKey> where TKey : IEquatable<TKey>
    {
	    private readonly Dictionary<TKey, Transition> _transitions = new();
        private readonly string _tag;
		private bool _shouldLogTransitions = false;

		private FiniteStateMachine(string ownerTag = "")
		{
			_tag = ownerTag != "" ? $"<b>{ownerTag} (FSM)</b>" : "<b>FSM</b>";
		}

		private ILogger _logger;

		/// <summary>
		/// Event triggered when the state changes.
		/// </summary>
		//TODO: Check if this should be replaced with the same UniTask list as in the Transition struct
		public event Action<Transition> OnTransition = delegate { };

		/// <summary>
		/// Current state running in the FSM
		/// </summary>
		public State Current { get; private set; }

		/// <summary>
		/// Call this to start the FSM
		/// </summary>
		/// <param name="state">The start state</param>
		public async UniTask Start(State state)
		{
			Current = state;
			await Current.Awake();
		}

		/// <summary>
		/// Do a transition previously added to this FSM.
		/// </summary>
		/// <param name="key">Key identifier for the transition <see cref="AddTransition"/></param>
		public async UniTask<bool> TryTransitionTo(TKey key)
		{
			if (!TryGetTransition(key, out var transition))
				return false;


			await transition.Do();
			Current = transition.To;
			OnTransition(transition);
			return true;
		}

		public bool TryAddTransition(TKey key, State from, State to, out Transition transition)
		{
			transition = new Transition(from, to, _shouldLogTransitions ? _logger : null, _tag);
			return TryAddTransition(key, transition);
		}

		public bool TryAddTransition(TKey key, Transition transition)
			=> _transitions.TryAdd(key, transition);

		public bool TryGetTransition(TKey key, out Transition transition)
			=> _transitions.TryGetValue(key, out transition);

		public bool TryRemoveTransition(TKey key, out Transition transition)
			=> _transitions.Remove(key, out transition);

		/// <summary>
		/// Builder method to simplify code.
		/// </summary>
		/// <param name="ownerTag">Used for logging</param>
		/// <returns>Builder class (Use method Done to get the desired state machine once the setup is completed).</returns>
		public static Builder Build(string ownerTag = "")
			=> new(ownerTag);


		public class Builder
		{
			private readonly FiniteStateMachine<TKey> _finiteStateMachine;

			/// <summary>
			/// Constructor
			/// </summary>
			/// <param name="ownerTag">Used for logging</param>
			internal Builder(string ownerTag = "")
				=> _finiteStateMachine = new FiniteStateMachine<TKey>(ownerTag);

			public Builder ThatLogsTransitions(ILogger logger, bool shouldLogTransitions = true)
			{
				_finiteStateMachine._logger = logger;
				_finiteStateMachine._shouldLogTransitions = shouldLogTransitions;
				return this;
			}


			public Builder ThatTriggersOnTransition(Action<Transition> eventHandler)
			{
				_finiteStateMachine.OnTransition += eventHandler;
				return this;
			}

			/// <summary>
			/// Adds a transition
			/// </summary>
			/// <param name="key"></param>
			/// <param name="from"></param>
			/// <param name="to"></param>
			/// <param name="onTransition"></param>
			/// <returns></returns>
			/// <exception cref="ArgumentException">If key is duplicated</exception>
			public Builder ThatTransitionsBetween(TKey key,
													State from,
													State to,
													Func<(State from, State to),
													UniTask> onTransition = null)
			{
				if (_finiteStateMachine.TryAddTransition(key, from, to, out var transition))
					transition.OnTransition.Add(onTransition);
				else
				{
					throw new ArgumentException(
						$"Invalid {nameof(key)} (already exists: {_finiteStateMachine._transitions.ContainsKey(key)})",
						nameof(key));
				}
				return this;
			}

			/// <summary>
			/// Finishes the building process
			/// </summary>
			/// <returns>The resulting state machine</returns>
			public FiniteStateMachine<TKey> Done()
				=> _finiteStateMachine;
		}
    }
}
