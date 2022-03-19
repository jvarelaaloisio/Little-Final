using UnityEngine;
public interface IPlayerInput
{
	/// <summary>
	/// Returns the input in the hor axis
	/// </summary>
	/// <returns></returns>
	Vector2 GetHorInput();
	/// <summary>
	/// Returns true if the player is pressing the climb button
	/// </summary>
	/// <returns></returns>
	bool GetClimbInput();
	/// <summary>
	/// Returns true if the player is pressing the jump button
	/// </summary>
	/// <returns></returns>
	bool GetJumpInput();
	/// <summary>
	/// Returns true if the player is pressing the long jump button
	/// </summary>
	/// <returns></returns>
	bool GetLongJumpInput();
	bool GetGlideInput();
	bool GetRunInput();
	bool GetSwirlInput();
	/// <summary>
	/// Returns true if the player is pressing the pick button
	/// </summary>
	/// <returns></returns>
	bool GetPickInput();
	/// <summary>
	/// Returns true if the player is pressing the throw button
	/// </summary>
	/// <returns></returns>
	bool GetThrowInput();
}