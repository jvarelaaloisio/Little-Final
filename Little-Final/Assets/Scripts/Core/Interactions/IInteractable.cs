namespace Core.Interactions
{
	public interface IInteractable
	{
		void Interact(IUser user);
		void Leave();
	}
}