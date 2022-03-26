using System;
using UnityEngine;
using Player.PlayerInput;

namespace Player.Abilities
{
	[CreateAssetMenu(menuName = "Abilities/Push", fileName = "Ability_Push")]
	public class Push : Ability
	{
		[SerializeField] private Vector3 direction;

		private ForceRequest _forceRequest;

		protected override bool ValidateInternal(PlayerController controller)
		{
			return InputManager.CheckSwirlInput();
		}

		public override void Use(PlayerController controller)
		{
			Debug.Log("push");
			controller.Body.RequestForce(new ForceRequest(controller.transform.TransformDirection(direction), ForceMode.Impulse));
		}
	}
}