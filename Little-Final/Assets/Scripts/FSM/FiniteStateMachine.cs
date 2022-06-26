using System;
using UnityEngine;

namespace FSM
{
	/// <summary>
	/// Finite state machine
	/// </summary>
	/// <typeparam name="T">The key Type to access the different states</typeparam>
	public class FiniteStateMachine<T>
	{
		private readonly string _tag;
		private bool _shouldLogTransitions = false;

		private FiniteStateMachine(State<T> initialState,
									string ownerTag = "")
		{
			CurrentState = initialState;
			CurrentState.Awake();
			_tag = ownerTag != "" ? $"<b>{ownerTag} (FSM)</b>" : "<b>FSM</b>";
		}

		private ILogger _logger;

		/// <summary>
		/// Event triggered when the state changes. First state is the last and second is the new one.
		/// </summary>
		public event Action<State<T>, State<T>> OnTransition = delegate { };

		/// <summary>
		/// Current state running in the FSM
		/// </summary>
		public State<T> CurrentState { get; private set; }

		/// <summary>
		/// Change the current state to another one in the dictionary.
		/// </summary>
		/// <param name="key">Key for the next state</param>
		public void TransitionTo(T key)
		{
			if (!CurrentState.TryGetTransition(key, out var transition))
				return;

			if (transition == CurrentState)
				return;

			CurrentState?.Sleep();

			if (_shouldLogTransitions)
				_logger.Log(_tag, $"transitioned: {Colored(CurrentState.Name, "yellow")} -> {Colored(transition.Name, "green")}");

			CurrentState = transition;
			CurrentState.Awake();
			OnTransition(CurrentState, transition);
		}

		/// <summary>
		/// Update method that runs the current state's Update.
		/// </summary>
		public void Update(float deltaTime)
			=> CurrentState.UpdateState(deltaTime);

		/// <summary>
		/// Builder method to simplify code.
		/// </summary>
		/// <param name="initialState">Base state for the FSM</param>
		/// <param name="ownerTag">Used for logging</param>
		/// <returns>Builder class (Use method Done to get the desired state machine once the setup is completed).</returns>
		public static Builder Build(State<T> initialState,
									string ownerTag = "")
			=> new Builder(initialState,
							ownerTag);
		
		private static string Colored(object message, string color) => $"<color={color}>{message}</color>";
		
		public class Builder
		{
			private readonly FiniteStateMachine<T> _finiteStateMachine;

			/// <summary>
			/// Constructor
			/// </summary>
			/// <param name="initialState">Base state for the FSM</param>
			/// <param name="ownerTag">Used for logging</param>
			internal Builder(State<T> initialState,
							string ownerTag = "")
				=> _finiteStateMachine = new FiniteStateMachine<T>(initialState,
																	ownerTag);

			public FiniteStateMachine<T> Done()
				=> _finiteStateMachine;

			public Builder ThatLogsTransitions(ILogger logger)
			{
				_finiteStateMachine._logger = logger;
				_finiteStateMachine._shouldLogTransitions = true;
				return this;
			}


			public Builder ThatTriggersOnTransition(Action<State<T>, State<T>> eventHandler)
			{
				_finiteStateMachine.OnTransition += eventHandler;
				return this;
			}
		}
	}
}