using System;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
	//using T = IDictionary<Type, IDictionary<IIdentification, object>>;

	public interface IState<T>
	{
		/// <summary>
		/// The name of the state
		/// </summary>
		string Name { get; set; }
		
		ILogger Logger { get; set; }

		/// <summary>
		/// Called once when the FSM enters the State
		/// </summary>
		List<Func<IState<T>, T, CancellationToken, UniTask>> OnEnter { get; }
		List<Func<IState<T>, T, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; }

		/// <summary>
		/// Called once when the FSM exits the State
		/// </summary>
		List<Func<IState<T>, T, CancellationToken, UniTask>> OnExit { get; }

		/// <summary>
		/// Method called once when entering this state and after exiting the last one.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		//TODO: refactor to UniTask<Hashtable>
		UniTask Enter(T data, CancellationToken token);
		
		/// <summary>
		/// Method called for every input received by the State machine.
		/// </summary>
		/// <returns></returns>
		UniTask<bool> TryHandleInput(T data, CancellationToken token);

		/// <summary>
		/// Method called once when exiting this state and before entering another.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		UniTask Exit(T data, CancellationToken token);
	}
}