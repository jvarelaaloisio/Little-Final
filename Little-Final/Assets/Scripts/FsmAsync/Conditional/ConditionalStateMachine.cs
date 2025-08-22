using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.FSM;
using Core.Helpers;
using Cysharp.Threading.Tasks;
using UnityEngine;


namespace FsmAsync.Conditional
{
	/// <summary>
	/// Finite state machine with async implementation of methods
	/// </summary>
	/// <typeparam name="TTarget">The data Type, for data storage across states.</typeparam>
	/// <typeparam name="TId">The type used as an id for <see cref="Transition{TTarget,TId}"/></typeparam>
	//TODO: This class should replace StateMachine once it's proven to work correctly.
	public class ConditionalStateMachine<TTarget, TId>
    {
	    private readonly Dictionary<IState<TTarget>, IList<ICondition<TTarget, ITransition<TTarget, TId>>>> _transitions = new();
	    public string Tag { get; }
        public bool EnableLog { get; private set; } = false;
        public ILogger Logger { get; private set; } = null;


		public ConditionalStateMachine(string ownerTag = "")
		{
			Tag = ownerTag != "" ? $"<b>{ownerTag} (FSM)</b>" : "<b>FSM</b>";
		}

		/// <summary>
		/// Event triggered when the state changes.
		/// </summary>
		//TODO: Check if this should be replaced with the same UniTask list as in the ITransition<TData> struct
		public event Action<ITransition<TTarget, TId>> OnTransition = delegate { };

		/// <summary>
		/// Current state running in the FSM
		/// </summary>
		public IState<TTarget> Current { get; private set; }

		public bool AllowInvalidTransitions { get; set; } = false;

		/// <summary>
		/// Call this to start the FSM
		/// </summary>
		/// <param name="state">The start state</param>
		/// <param name="token"></param>
		/// <param name="data"></param>
		public async UniTask Start(IState<TTarget> state, TTarget data, CancellationToken token)
		{
			Current = state;
			await Current.Enter(data, token);
		}

		/// <summary>
		/// Call this to end/disable the fsm
		/// </summary>
		/// <param name="data"></param>
		/// <param name="token"></param>
		public async UniTask End(TTarget data, CancellationToken token)
			=> await Current.Exit(data, token);

		/// <summary>
		/// Do a transition previously added to this FSM.
		/// </summary>
		/// <param name="data"></param>
		/// <param name="token"></param>
		public async UniTask<ITransition<TTarget, TId>> TryGetTransition(TTarget data, CancellationToken token)
		{
			if (!TryGetConditions(Current, out var conditions))
				return null;

			foreach (var condition in conditions)
			{
				if (!await condition.IsMet(data, out var transition, token)
				    || IsAlreadyInState(transition)
				    || IsInvalidTransition(transition))
					continue;

				if (EnableLog)
					Logger.Log($"Condition ( {condition.Name.Colored(C.Yellow)}) has been met");
				return transition;
			}
			return null;

			bool IsAlreadyInState(ITransition<TTarget, TId> transition)
				=> transition.To == Current;

			bool IsInvalidTransition(ITransition<TTarget, TId> transition)
				=> transition.From != Current && !AllowInvalidTransitions;
		}

		public bool TryAddTransition(IState<TTarget> state, ICondition<TTarget, ITransition<TTarget, TId>> condition)
		{
			if (!TryGetConditions(state, out var conditions))
			{
				_transitions.Add(state, new List<ICondition<TTarget, ITransition<TTarget, TId>>> { condition });
				return true;
			}

			if (conditions.Contains(condition))
				return false;

			conditions.Add(condition);
			return true;
		}

		public bool TryGetConditions(IState<TTarget> state, out IList<ICondition<TTarget, ITransition<TTarget, TId>>> condition)
			=> _transitions.TryGetValue(state, out condition);

		public bool TryRemoveTransition(IState<TTarget> state, ICondition<TTarget, ITransition<TTarget, TId>> condition)
			=> TryGetConditions(state, out var conditions)
			   && conditions.Remove(condition);

		public bool TryRemoveTransition(IState<TTarget> state, ITransition<TTarget, TId> transition)
		{
			if (!TryGetConditions(state, out var conditions))
				return false;
			var foundTransition = conditions.FirstOrDefault(condition => condition.Output == transition);
			return foundTransition != null
			       && conditions.Remove(foundTransition);
		}

		public async UniTask DoTransition((TTarget target, ITransition<TTarget, TId> transition) data, CancellationToken token)
		{
			await data.transition.Do(data.target, EnableLog, token);
			Current = data.transition.To;
			OnTransition(data.transition);
		}

		public ConditionalStateMachine<TTarget, TId> ThatLogs(UnityEngine.ILogger logger, bool shouldLogTransitions = true)
		{
			Logger = logger;
			EnableLog = shouldLogTransitions;
			return this;
		}
	}
}
