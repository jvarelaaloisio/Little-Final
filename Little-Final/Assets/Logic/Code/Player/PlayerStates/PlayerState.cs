using System.Diagnostics;

public abstract class PlayerState
{
	protected PlayerModel model;

	/// <summary>
	/// Runs once when the state starts
	/// </summary>
	/// <param name="brain"></param>
	/// <param name="sceneIndex">the index where the player lives</param>
	public virtual void OnStateEnter(PlayerModel brain, int sceneIndex)
	{
		model = brain;
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
