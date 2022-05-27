using System;
using FSM;
using UnityEngine;

namespace Rideables.States
{
	public class CharacterState<T> : State<T>
	{
		protected readonly Transform MyTransform;
		protected Action CompletedObjective;
		public CharacterState(string name,
							Transform transform,
							Action onCompletedObjective)
			: base(name)
		{
			MyTransform = transform;
			CompletedObjective = onCompletedObjective;
		}
	}
}
