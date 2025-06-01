using Characters;
using FsmAsync;

namespace User.States
{
	public interface ICharacterState : IState
	{
		ICharacter Character { get; set; }
	}
}