using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
using CharacterMovement;
using Player;
using Player.Abilities;
using Player.PlayerInput;
using Player.States;

[CreateAssetMenu(menuName = "Abilities/Swirl", fileName = "Ability_Swirl")]
public class Swirl : Ability
{
	public string animationStateName;
	public Vector3 force;
	private PlayerController _controller;
	public override void Use(PlayerController controller)
	{
		this._controller = controller;
		Vector3 forceLocal = controller.transform.right * force.x + controller.transform.up * force.y + controller.transform.forward * force.z;
		controller.Body.Velocity = Vector3.zero;
		controller.Body.Push(forceLocal);
		controller.OnSpecificAction(animationStateName);
		controller.ChangeState<Void>();
		IsOnCoolDown = true;
		CooldownTimer = new CountDownTimer(cooldown, OnFinished, controller.SceneIndex);
		CooldownTimer.StartTimer();
	}
	protected override bool ValidateInternal(PlayerController controller)
	{
		return InputManager.CheckSwirlInput();
	}

	private void OnFinished()
	{
		_controller.GetComponent<Rigidbody>().useGravity = true;
		IsOnCoolDown = false;
		if (FallHelper.IsGrounded)
			_controller.ChangeState<Walk>();
		else
			_controller.ChangeState<LongJump>();
	}
}
