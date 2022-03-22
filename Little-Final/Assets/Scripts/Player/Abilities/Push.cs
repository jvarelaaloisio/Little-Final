using UnityEngine;
using Player.PlayerInput;

namespace Player.Abilities
{
	[CreateAssetMenu(menuName = "Abilities/Push", fileName = "Ability_Push")]
	public class Push : Ability
	{
		[SerializeField] private Vector3 direction;
		
		public override bool ValidateTrigger(PlayerController controller)
		{
			return InputManager.CheckSwirlInput();
		}

		public override void Use(PlayerController controller)
		{
			Debug.Log("push");
			controller.Body.Push(controller.transform.TransformDirection(direction));
		}
	}
}