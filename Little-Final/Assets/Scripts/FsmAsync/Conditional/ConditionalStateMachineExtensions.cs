using Core.FSM;

namespace FsmAsync.Conditional
{
	public static class ConditionalStateMachineExtensions
	{
		public static TransitionBuilder<TTarget, TId> ThatTransitionsFrom<TTarget, TId>(this ConditionalStateMachine<TTarget, TId> stateMachine,
																			  IState<TTarget> state)
			=> TransitionBuilder<TTarget, TId>.From(stateMachine, state);
	}
}