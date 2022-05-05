using CharacterMovement;
using Player.PlayerInput;
using UnityEngine;

namespace Player.States
{
	public class Ride : State
	{
		private IRideable _rideable;

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			_rideable = controller.Rideable;
			if (_rideable == null)
			{
				Debug.Log("no rideable found");
				controller.ChangeState<Walk>();
				return;
			}

			controller.GetComponent<Rigidbody>().isKinematic = true;
		}

		public override void OnStateUpdate()
		{
			var input = InputManager.GetHorInput();
			var direction = MoveHelper.GetDirection(input);
			Controller.Rideable.Move(direction);
			if (InputManager.CheckRunInput())
				_rideable.UseAbility();
			if (InputManager.CheckInteractInput())
			{
				Controller.Body.Jump(Vector3.up * PP_Jump.JumpForce - MyTransform.forward * PP_Jump.JumpForce);
				Controller.ChangeState<Jump>();
			}
		}

		public override void OnStateExit()
		{
			Controller.Dismount();
			Controller.GetComponent<Rigidbody>().isKinematic = false;
		}
	}
}