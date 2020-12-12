using System.Diagnostics;

public abstract class PlayerState
{
	protected PlayerController brain;

	/// <summary>
	/// Runs once when the state starts
	/// </summary>
	/// <param name="brain"></param>
	public virtual void OnStateEnter(PlayerController brain)
	{
		this.brain = brain;
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
