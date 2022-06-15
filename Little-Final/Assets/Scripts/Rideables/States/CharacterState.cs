using System;
using Core.Debugging;
using FSM;
using UnityEngine;

namespace Rideables.States
{
	public class CharacterState<T> : State<T>
	{
		protected readonly Transform MyTransform;
		protected readonly Action CompletedObjective;
		protected readonly Debugger Debugger;

		public CharacterState(string name,
							Transform transform,
							Action onCompletedObjective,
							Debugger debugger)
			: base(name)
		{
			MyTransform = transform;
			CompletedObjective = onCompletedObjective;
			Debugger = debugger;
		}
	}
}
