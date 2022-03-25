using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.Abilities
{
	public abstract class Ability : ScriptableObject
	{
		[SerializeField]
		[Range(0, 500)]
		protected int stamina;

		[SerializeField]
		protected float cooldown;
		protected bool IsOnCoolDown;
		protected CountDownTimer CooldownTimer;

		public virtual int Stamina => stamina;

		private void OnEnable()
		{
			IsOnCoolDown = false;
		}
		
		public virtual bool ValidateTrigger(PlayerController controller)
		{
			return (!IsOnCoolDown
			        && controller.Stamina.FillState >= stamina
			        && ValidateInternal(controller));
		}

		protected abstract bool ValidateInternal(PlayerController controller);
		
		public abstract void Use(PlayerController controller);
	}
}