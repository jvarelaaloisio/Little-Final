using System;

namespace FsmAsync
{
	public static class FiniteStateMachineExtensions
	{
		/// <summary>
		/// Add a transition between 2 states through a key. Simplifies the process of creating and adding a transition.
		/// </summary>
		/// <param name="target"></param>
		/// <param name="key"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="transition"><remarks>This transition is internally of type <see cref="Transition{TData}"/></remarks></param>
		/// <returns>true if the transition was successfully added.</returns>
		public static bool TryAddTransition<TKey, TData>(this FiniteStateMachine<TKey, TData> target,
		                                          TKey key,
		                                          IState<TData> from,
		                                          IState<TData> to,
		                                          out ITransition<TData> transition) where TKey : IEquatable<TKey>
		{
			transition = new Transition<TData>(from, to, target.Logger, target.Tag);
			return target.TryAddTransition(key, transition);
		}
	}
}