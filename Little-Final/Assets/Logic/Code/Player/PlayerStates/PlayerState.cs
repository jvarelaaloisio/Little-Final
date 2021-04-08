
public abstract class PlayerState
{
	protected PlayerController Controller;

	/// <summary>
	/// Runs once when the state starts
	/// </summary>
	/// <param name="controller"></param>
	/// <param name="sceneIndex">the index where the player lives</param>
	public virtual void OnStateEnter(PlayerController controller, int sceneIndex)
	{
		this.Controller = controller;
	}
	/// <summary>
	/// Runs every update
	/// </summary>
	public abstract void OnStateUpdate();
	/// <summary>
	/// runs once when the state finishes
	/// </summary>
	public virtual void OnStateExit() { }
}