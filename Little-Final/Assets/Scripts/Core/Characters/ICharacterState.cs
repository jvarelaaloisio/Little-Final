using System;
using Characters;
using FsmAsync;

namespace User.States
{
	//THOUGHT: Is this necessary now that we have the data in the transitions?
	[Obsolete("Replace with a search on the actor's data")]
	public interface ICharacterState<T> : IState<T>
	{
		ICharacter Character { get; set; }
	}
}