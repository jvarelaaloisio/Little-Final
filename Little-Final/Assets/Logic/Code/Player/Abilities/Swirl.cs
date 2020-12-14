using UnityEngine;
using UpdateManagement;
using CharacterMovement;
[CreateAssetMenu(menuName = "Abilities/Swirl", fileName = "Ability_Swirl")]
public class Swirl : Ability
{
	public string animationStateName;
	public Vector3 force;
	public float cooldown;
	private bool isCoolDown;
	private PlayerModel model;
	public override int Stamina => stamina;
	public override void Use(PlayerModel model)
	{
		this.model = model;
		Vector3 forceLocal = model.transform.right * force.x + model.transform.up * force.y + model.transform.forward * force.z;
		model.Body.Velocity = Vector3.zero;
		model.Body.Push(forceLocal);
		model.view.PlaySpecificAnimation(animationStateName);
		model.ChangeState<PS_Idle>();
		isCoolDown = true;
		new CountDownTimer(cooldown, OnFinished).StartTimer();
	}

	public override bool ValidateTrigger(PlayerModel model)
	{
		return !isCoolDown && model.stamina.FillState >= stamina && InputManager.CheckSwirlInput();
	}

	private void OnFinished()
	{
		Debug.Log("swirl finished");
		model.GetComponent<Rigidbody>().useGravity = true;
		isCoolDown = false;
		if (FallHelper.IsGrounded)
			model.ChangeState<PS_Walk>();
		else
			model.ChangeState<PS_LongJump>();
	}
}
