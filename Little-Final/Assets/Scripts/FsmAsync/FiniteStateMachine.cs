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
    /// Finite state machine with async implementation of methods
    /// </summary>
    /// <typeparam name="TKey">The key Type to access the different states</typeparam>
    public class FiniteStateMachine<TKey> where TKey : IEquatable<TKey>
    {
	    private readonly Dictionary<int, ITransition> _transitions = new();
	    public string Tag { get; }
        public bool ShouldLogTransitions { get; private set; } = false;
        public ILogger Logger { get; private set; } = null;


		private FiniteStateMachine(string ownerTag = "")
		{
			Tag = ownerTag != "" ? $"<b>{ownerTag} (FSM)</b>" : "<b>FSM</b>";
		}

		/// <summary>
		/// Event triggered when the state changes.
		/// </summary>
		//TODO: Check if this should be replaced with the same UniTask list as in the ITransition struct
		public event Action<ITransition> OnTransition = delegate { };

		/// <summary>
		/// Current state running in the FSM
		/// </summary>
		public IState Current { get; private set; }

		public bool AllowInvalidTransitions { get; set; } = false;

		/// <summary>
		/// Call this to start the FSM
		/// </summary>
		/// <param name="state">The start state</param>
		/// <param name="token"></param>
		/// <param name="data"></param>
		public async UniTask Start(IState state, IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
		{
			Current = state;
			await Current.Enter(data, token);
		}

		/// <summary>
		/// Do a transition previously added to this FSM.
		/// </summary>
		/// <param name="key">Key identifier for the transition <see cref="AddTransition"/></param>
		/// <param name="data"></param>
		public async UniTask<bool> TryTransitionTo(TKey key, CancellationToken token, IDictionary<Type, IDictionary<IIdentification, object>> data = null)
		{
			if (!TryGetTransition(Current, key, out var transition))
				return false;

			if (transition.To == Current)
				return false;

			if (transition.From != Current && !AllowInvalidTransitions)
			{
				Logger.LogError(Tag, $"ITransition({key}).From({transition.From.Name}) != {Current.Name} & {nameof(AllowInvalidTransitions)}: false");
				return false;
			}

			await transition.Do(data, token);
			Current = transition.To;
			OnTransition(transition);
			return true;
		}

		public bool TryAddTransition(TKey key, ITransition transition)
		{
			var hashKey = HashCode.Combine(key, transition.From);
			return _transitions.TryAdd(hashKey, transition);
		}

		public bool TryGetTransition(IState from, TKey key, out ITransition transition)
			=> _transitions.TryGetValue(HashCode.Combine(key, from), out transition);

		public bool TryRemoveTransition(IState from, TKey key, out ITransition transition)
			=> _transitions.Remove(HashCode.Combine(key, from), out transition);

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
				_finiteStateMachine.Logger = logger;
				_finiteStateMachine.ShouldLogTransitions = shouldLogTransitions;
				return this;
			}

			/// <summary>
			/// Sets <see cref="FiniteStateMachine{TKey}.AllowInvalidTransitions"/> to true.
			/// </summary>
			/// <param name="allowInvalidTransitions"></param>
			/// <returns></returns>
			public Builder ThatAllowsInvalidTransitions(bool allowInvalidTransitions = true)
			{
				_finiteStateMachine.AllowInvalidTransitions = allowInvalidTransitions;
				return this;
			}

			public Builder ThatTriggersOnTransition(Action<ITransition> eventHandler)
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
													IState from,
													IState to,
													Func<(IState from, IState to),
													UniTask> onTransition = null)
			{
				var addedTransition = _finiteStateMachine.TryAddTransition(key, from, to, out var transition);
				if (addedTransition)
				{
					if (onTransition != null)
						transition.OnTransition.Add(onTransition);
				}
				else
					_finiteStateMachine.Logger?.LogError(_finiteStateMachine.Tag, $"Couldn't add transition: {key}: ({from?.Name} - {to?.Name})");
				if (addedTransition && onTransition != null)
					transition.OnTransition.Add(onTransition);
				return this;
			}

			/// <summary>
			/// Finishes the building process
			/// </summary>
			/// <returns>The resulting state machine</returns>
			public FiniteStateMachine<TKey> Done()
				=> _finiteStateMachine;
		}

		public async UniTask HandleInput(TKey key,
		                                 CancellationToken token,
		                                 IDictionary<Type,IDictionary<IIdentification,object>> data,
		                                 bool logIfError = false)
		{
			if (await TryTransitionTo(key, token, data))
				return;
			if (await Current.TryHandleInput(data, token))
				return;
			if (logIfError)
				Logger.LogError(Tag, $"Couldn't transition from state {Current.Name} using key {key}");
		}

    }
	public struct InputData<TKey>
	{
		public TKey stateId;
		public IDictionary<Type, IDictionary<IIdentification, object>> data;

		public InputData(TKey stateId, IDictionary<Type, IDictionary<IIdentification, object>> data)
		{
			this.stateId = stateId;
			this.data = data;
		}
	}
}
