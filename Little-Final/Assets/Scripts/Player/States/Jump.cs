using CharacterMovement;
using Player.PlayerInput;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Jump : State
	{
		protected IBody Body;

		private const float MIN_TIME_BEFORE_GLIDE = .1f;
		private bool _canGlide = false;

		private CountDownTimer _waitBeforeGlide;

		public Jump()
		{
			Flags.allowsLanding = true;
		}

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			MyTransform = controller.transform;

			Body = controller.Body;
			Body.BodyEvents += BodyEventsHandler;

			_waitBeforeGlide = new CountDownTimer(
				MIN_TIME_BEFORE_GLIDE,
				() => _canGlide = true,
				sceneIndex
			);
			_waitBeforeGlide.StartTimer();
		}

		public override void OnStateUpdate()
		{
			//TODO: Delete this and only use moveByForce once the movement tests are finished
			if (Input.GetKey(KeyCode.RightControl))
			{
				MoveHorizontally(Body, PP_Jump.JumpSpeed, PP_Jump.TurnSpeedInTheAir);
			}
			else
			{
				Controller.MoveByForce(PP_Jump.MovementForce, PP_Jump.TurnSpeedInTheAir);
			}

			CheckForJumpBuffer();
			CheckClimb();
			Controller.RunAbilityList(Controller.AbilitiesInAir);
			CheckGlide();
		}

		public override void OnStateExit()
		{
			//-- Debería irse cuando refactorize para que el controller haga los cambios
			_waitBeforeGlide.StopTimer();
			//-- A glide
			Controller.OnGlideChanges(false);
			Body.BodyEvents -= BodyEventsHandler;
			//-- A glide
			Body.SetDrag(0);
		}

		private void BodyEventsHandler(BodyEvent eventType)
		{
			if (eventType.Equals(BodyEvent.LAND)
			    && FallHelper.IsGrounded)
				Controller.ChangeState<Walk>();
		}

		//-- A Glide
		protected virtual void CheckGlide()
		{
			if (_canGlide
			    && InputManager.GetGlideInput()
			    && !(Controller.Stamina.FillState < 1)
			    && !(Body.Velocity.y > 0))
				Controller.ChangeState<Glide>();
		}
	}
}