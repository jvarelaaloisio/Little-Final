using System;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;

namespace FsmAsync
{
	public interface IState<TTarget>
	{
		/// <summary>
		/// The name of the state
		/// </summary>
		string Name { get; set; }

		/// <summary>
		/// Called once when the FSM enters the State
		/// </summary>
		List<Func<IState<TTarget>, TTarget, CancellationToken, UniTask>> OnEnter { get; }
		List<Func<IState<TTarget>, TTarget, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; }

		/// <summary>
		/// Called once when the FSM exits the State
		/// </summary>
		List<Func<IState<TTarget>, TTarget, CancellationToken, UniTask>> OnExit { get; }

		/// <summary>
		/// Method called once when entering this state and after exiting the last one.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		UniTask Enter(TTarget target, CancellationToken token);
		
		/// <summary>
		/// Method called for every input received by the State machine.
		/// </summary>
		/// <returns></returns>
		UniTask<bool> TryHandleDataChanged(TTarget target, CancellationToken token);

		/// <summary>
		/// Method called once when exiting this state and before entering another.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		UniTask Exit(TTarget target, CancellationToken token);
	}
}