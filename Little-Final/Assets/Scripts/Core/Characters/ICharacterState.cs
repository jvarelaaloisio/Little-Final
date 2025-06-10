using Characters;
using FsmAsync;

namespace User.States
{
	public interface ICharacterState<T> : IState<T>
	{
		ICharacter Character { get; set; }
	}
}