using System;
using System.Threading;
using Core.FSM;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync.Conditional
{
	public class TransitionBuilder<TTarget, TId>
	{
		private ConditionalStateMachine<TTarget, TId> _stateMachine;
		private IState<TTarget> _from;
		private IState<TTarget> _to;
		private TId _id;
		private Predicate<TTarget> _predicate;
		private Func<TTarget, CancellationToken, UniTask<bool>> _predicateTask;
		private string _predicateName;

		public static TransitionBuilder<TTarget, TId> From(ConditionalStateMachine<TTarget, TId> stateMachine,
														   IState<TTarget> from)
			=> new() {_stateMachine = stateMachine, _from = from};

		public TransitionBuilder<TTarget, TId> To(IState<TTarget> to)
		{
			_to = to;
			return this;
		}

		public TransitionBuilder<TTarget, TId> When(Predicate<TTarget> predicate)
		{
			_predicate = predicate;
			_predicateName = _predicate.Method.Name;
			return this;
		}
		public TransitionBuilder<TTarget, TId> WhenNot(Predicate<TTarget> predicate)
		{
			_predicate = target => !predicate(target);
			_predicateName = _predicate.Method.Name + ".Negated";
			return this;
		}

		public TransitionBuilder<TTarget, TId> When(string name, Predicate<TTarget> predicate)
		{
			_predicate = predicate;
			_predicateName = name;
			return this;
		}

		public TransitionBuilder<TTarget, TId> WhenNot(string name, Predicate<TTarget> predicate)
		{
			_predicate = target => !predicate(target);
			_predicateName = name + ".Negated";
			return this;
		}

		public TransitionBuilder<TTarget, TId> When(Func<TTarget, CancellationToken, UniTask<bool>> predicate)
		{
			_predicateTask = predicate;
			_predicateName = _predicate.Method.Name;
			return this;
		}

		public TransitionBuilder<TTarget, TId> When(string name, Func<TTarget, CancellationToken, UniTask<bool>> predicate)
		{
			_predicateTask = predicate;
			_predicateName = name;
			return this;
		}

		public TransitionBuilder<TTarget, TId> WithId(TId id){
			_id = id;
			return this;
		}

		public ConditionalStateMachine<TTarget, TId> Apply(){
			var condition = _predicate != null
				? new Condition<TTarget, ITransition<TTarget, TId>>(_predicate,
																	new Transition<TTarget, TId>(_from,
																								 _to,
																								 _id,
																								 _stateMachine
																									 .Logger,
																								 _stateMachine
																									 .Tag),
																	_predicateName)
				: new Condition<TTarget, ITransition<TTarget, TId>>(_predicateTask,
																	new Transition<TTarget, TId>(_from,
																								 _to,
																								 _id,
																								 _stateMachine.Logger,
																								 _stateMachine.Tag),
																	_predicateName);
			return AddCondition(condition);
		}

		private ConditionalStateMachine<TTarget, TId> AddCondition(Condition<TTarget, ITransition<TTarget, TId>> condition)
		{
			if (!_stateMachine.TryAddTransition(_from, condition))
				(_stateMachine?.Logger ?? Debug.unityLogger)
					.LogError(_stateMachine?.Tag, $"Couldn't add transition from {_from.Name}");

			return _stateMachine;
		}
	}
}