namespace Core.Interactions
{
	public interface IInteractable
	{
		void Interact(IInteractor interactor);
		void Leave();
	}
}