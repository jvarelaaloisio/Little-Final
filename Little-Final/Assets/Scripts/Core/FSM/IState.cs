using System;
using System.Collections.Generic;
using System.Threading;
using Core.Helpers;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
	public interface IState
	{
		/// <summary>
		/// The name of the state
		/// </summary>
		string Name { get; set; }
		
		ILogger Logger { get; set; }

		/// <summary>
		/// Called once when the FSM enters the State
		/// </summary>
		List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask>> OnEnter { get; }
		List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; }

		/// <summary>
		/// Called once when the FSM exits the State
		/// </summary>
		List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask>> OnExit { get; }

		/// <summary>
		/// Method called once when entering this state and after exiting the last one.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		//TODO: refactor to UniTask<Hashtable>
		UniTask Enter(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token);
		
		/// <summary>
		/// Method called for every input received by the State machine.
		/// </summary>
		/// <returns></returns>
		UniTask<bool> TryHandleInput(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token);

		/// <summary>
		/// Method called once when exiting this state and before entering another.
		/// <remarks>Always call base method so the corresponding event is raised</remarks>
		/// </summary>
		UniTask Exit(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token);
	}
}