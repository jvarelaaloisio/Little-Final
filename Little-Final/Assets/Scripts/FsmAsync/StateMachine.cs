using System;
using System.Collections.Generic;
using System.Threading;
using Core.FSM;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
	/// <summary>
	/// Finite state machine with async implementation of methods
	/// </summary>
	/// <typeparam name="TKey">The key Type to access the different states.</typeparam>
	/// <typeparam name="TData">The data Type, for data storage across states.</typeparam>
	[Obsolete("Use ConditionalStateMachine (this class should be removed and the other one should take it's place if it's verified to work correctly.")]
	public class StateMachine<TKey, TData> where TKey : IEquatable<TKey>
    {
	    private readonly Dictionary<int, ITransition<TData, TKey>> _transitions = new();
	    public string Tag { get; }
        public bool ShouldLogTransitions { get; private set; } = false;
        public ILogger Logger { get; private set; } = null;


		private StateMachine(string ownerTag = "")
		{
			Tag = ownerTag != "" ? $"<b>{ownerTag} (FSM)</b>" : "<b>FSM</b>";
		}

		/// <summary>
		/// Event triggered when the state changes.
		/// </summary>
		//TODO: Check if this should be replaced with the same UniTask list as in the ITransition<TData> struct
		public event Action<ITransition<TData, TKey>> OnTransition = delegate { };

		/// <summary>
		/// Current state running in the FSM
		/// </summary>
		public IState<TData> Current { get; private set; }

		public bool AllowInvalidTransitions { get; set; } = false;

		/// <summary>
		/// Call this to start the FSM
		/// </summary>
		/// <param name="state">The start state</param>
		/// <param name="token"></param>
		/// <param name="data"></param>
		public async UniTask Start(IState<TData> state, TData data, CancellationToken token)
		{
			Current = state;
			await Current.Enter(data, token);
		}

		/// <summary>
		/// Call this to end/disable the fsm
		/// </summary>
		/// <param name="data"></param>
		/// <param name="token"></param>
		public async UniTask End(TData data, CancellationToken token)
			=> await Current.Exit(data, token);

		/// <summary>
		/// Do a transition previously added to this FSM.
		/// </summary>
		/// <param name="key">Key identifier for the transition <see cref="TryAddTransition"/></param>
		/// <param name="data"></param>
		/// <param name="token"></param>
		public async UniTask<bool> TryTransitionTo(TKey key, TData data, CancellationToken token)
		{
			if (!TryGetTransition(Current, key, out var transition))
				return false;

			if (transition.To == Current)
				return false;

			if (transition.From != Current && !AllowInvalidTransitions)
			{
				Logger.LogError(Tag, $"ITransition<TData>({key}).From({transition.From.Name}) != {Current.Name} & {nameof(AllowInvalidTransitions)}: false");
				return false;
			}

			await transition.Do(data, ShouldLogTransitions, token);
			Current = transition.To;
			OnTransition(transition);
			return true;
		}

		public bool TryAddTransition(TKey key, ITransition<TData, TKey> transition)
		{
			var hashKey = HashCode.Combine(key, transition.From);
			return _transitions.TryAdd(hashKey, transition);
		}

		public bool TryGetTransition(IState<TData> from, TKey key, out ITransition<TData, TKey> transition)
			=> _transitions.TryGetValue(HashCode.Combine(key, from), out transition);

		public bool TryRemoveTransition(IState<TData> from, TKey key, out ITransition<TData, TKey> transition)
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
			private readonly StateMachine<TKey, TData> _stateMachine;

			/// <summary>
			/// Constructor
			/// </summary>
			/// <param name="ownerTag">Used for logging</param>
			internal Builder(string ownerTag = "")
				=> _stateMachine = new StateMachine<TKey, TData>(ownerTag);

			public Builder ThatLogsTransitions(ILogger logger, bool shouldLogTransitions = true)
			{
				_stateMachine.Logger = logger;
				_stateMachine.ShouldLogTransitions = shouldLogTransitions;
				return this;
			}

			/// <summary>
			/// Sets <see cref="StateMachine{TKey,TData}.AllowInvalidTransitions"/> to true.
			/// </summary>
			/// <param name="allowInvalidTransitions"></param>
			/// <returns></returns>
			public Builder ThatAllowsInvalidTransitions(bool allowInvalidTransitions = true)
			{
				_stateMachine.AllowInvalidTransitions = allowInvalidTransitions;
				return this;
			}

			public Builder ThatTriggersOnTransition(Action<ITransition<TData, TKey>> eventHandler)
			{
				_stateMachine.OnTransition += eventHandler;
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
													IState<TData> from,
													IState<TData> to,
													Func<(IState<TData> from, IState<TData> to), UniTask> onTransition = null)
			{
				var addedTransition = _stateMachine.TryAddTransition(key, from, to, out var transition);
				if (addedTransition)
				{
					if (onTransition != null)
						transition.OnTransition.Add(onTransition);
				}
				else
					_stateMachine.Logger?.LogError(_stateMachine.Tag, $"Couldn't add transition: {key}: ({from?.Name} - {to?.Name})");
				if (addedTransition && onTransition != null)
					transition.OnTransition.Add(onTransition);
				return this;
			}

			/// <summary>
			/// Finishes the building process
			/// </summary>
			/// <returns>The resulting state machine</returns>
			public StateMachine<TKey, TData> Done()
				=> _stateMachine;
		}

		public async UniTask<bool> HandleDataChanged(TData data,
		                                 TKey key,
		                                 CancellationToken token)
		{
			if (await TryTransitionTo(key, data, token))
				return true;
			return await Current.Tick(data, token);
		}

    }
}
