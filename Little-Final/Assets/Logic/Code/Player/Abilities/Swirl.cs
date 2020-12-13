using UnityEngine;
using UpdateManagement;
[CreateAssetMenu(menuName = "Abilities/Swirl", fileName = "Ability_Swirl")]
public class Swirl : Ability
{
	public string animationStateName;
	public Vector3 force;
	public float cooldown;
	private bool isCoolDown;
	public override int Stamina => stamina;
	public override void Use(PlayerModel model)
	{
		Vector3 forceLocal = model.transform.right * force.x + model.transform.up * force.y + model.transform.forward * force.z;
		model.Body.Push(forceLocal);
		model.view.PlaySpecificAnimation(animationStateName);
		model.ChangeState<PS_LongJump>();
		isCoolDown = true;
		new CountDownTimer(cooldown, () => isCoolDown = false).StartTimer();
	}

	public override bool ValidateTrigger(PlayerModel model)
	{
		return !isCoolDown && model.stamina.FillState >= stamina && InputManager.CheckSwirlInput();
	}
}
