using CharacterMovement;
using Core.Gameplay;
using Core.Interactions;
using Player.PlayerInput;
using UnityEngine;

namespace Player.States
{
	public class Ride : State
	{
		private IRideable _rideable;

		public override void OnStateEnter(PlayerController controller, IInputReader inputReader, int sceneIndex)
		{
			base.OnStateEnter(controller, inputReader, sceneIndex);
			_rideable = controller.Rideable;
			if (_rideable == null)
			{
				Debug.Log("no rideable found");
				controller.ChangeState<Walk>();
				return;
			}

			controller.GetComponent<Rigidbody>().isKinematic = true;
			controller.OnRide.Invoke();
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
				Controller.Body.Jump(MyTransform.TransformDirection(-PP_Jump.Force));
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