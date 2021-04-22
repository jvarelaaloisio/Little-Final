using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
using CharacterMovement;
using Player;
using Player.PlayerInput;
using Player.States;

[CreateAssetMenu(menuName = "Abilities/Swirl", fileName = "Ability_Swirl")]
public class Swirl : Ability
{
	public string animationStateName;
	public Vector3 force;
	public float cooldown;
	private bool isCoolDown;
	private PlayerController _controller;
	private CountDownTimer cooldownTimer;
	public override int Stamina => stamina;
	public override void Use(PlayerController controller)
	{
		this._controller = controller;
		Vector3 forceLocal = controller.transform.right * force.x + controller.transform.up * force.y + controller.transform.forward * force.z;
		controller.Body.Velocity = Vector3.zero;
		controller.Body.Push(forceLocal);
		controller.OnSpecificAction(animationStateName);
		controller.ChangeState<Void>();
		isCoolDown = true;
		cooldownTimer = new CountDownTimer(cooldown, OnFinished, controller.SceneIndex);
		cooldownTimer.StartTimer();
	}
	private void OnEnable()
	{
		isCoolDown = false;
	}
	public override bool ValidateTrigger(PlayerController controller)
	{
		return !isCoolDown && controller.Stamina.FillState >= stamina && InputManager.CheckSwirlInput();
	}

	private void OnFinished()
	{
		_controller.GetComponent<Rigidbody>().useGravity = true;
		isCoolDown = false;
		if (FallHelper.IsGrounded)
			_controller.ChangeState<Walk>();
		else
			_controller.ChangeState<LongJump>();
	}
}
