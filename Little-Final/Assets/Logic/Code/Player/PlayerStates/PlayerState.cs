
public abstract class PlayerState
{
	protected PlayerModel Model;

	/// <summary>
	/// Runs once when the state starts
	/// </summary>
	/// <param name="model"></param>
	/// <param name="sceneIndex">the index where the player lives</param>
	public virtual void OnStateEnter(PlayerModel model, int sceneIndex)
	{
		this.Model = model;
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
