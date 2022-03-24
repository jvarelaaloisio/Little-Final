using CharacterMovement;
using Player.PlayerInput;
using Player.Properties;
using Player.Stamina;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Glide : State
	{
		protected IBody Body;
		protected StaminaConsumer Consumer;
		protected CountDownTimer SetFlight;

		public Glide() =>
			Flags = (
				allowsLanding: true,
				allowsJump: false,
				allowsJumpBuffer: true,
				allowsClimb: true
			);

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			Body = controller.Body;
			Body.BodyEvents += BodyEventsHandler;
			controller.OnGlideChanges(true);
			Body.SetDrag(PP_Glide.Drag);

			SetupConsumer(sceneIndex);
			Consumer.Start();
			SetFlight = new CountDownTimer(
				PP_Glide.TimeBeforeFlight,
				controller.ChangeState<Fly>,
				sceneIndex
			);
			SetFlight.StartTimer();
		}

		public override void OnStateUpdate()
		{
			Move();

			if (!InputManager.GetGlideInput()
			    || Controller.Stamina.FillState < 1
			    || Body.Velocity.y > 0)
				Controller.ChangeState<Jump>();

			CheckClimb();
			CheckForJumpBuffer();
			Controller.RunAbilityList(Controller.AbilitiesInAir);
		}

		public override void OnStateExit()
		{
			Controller.OnGlideChanges(false);
			Consumer.Stop();
			SetFlight.StopTimer();
			Body.BodyEvents -= BodyEventsHandler;
			Body.SetDrag(0);
		}

		protected virtual void Move()
		{
			//TODO: Delete this and only use moveByForce once the movement tests are finished
			if (Input.GetKey(KeyCode.RightControl))
			{
				MoveHorizontally(Body, 6f, PP_Glide.TurnSpeed);
			}
			else
			{
				Controller.MoveByForce(PP_Glide.Force, PP_Glide.TurnSpeed);
			}
		}

		protected virtual void SetupConsumer(int sceneIndex)
		{
			Consumer = new StaminaConsumer(
				Controller.Stamina,
				PP_Glide.StaminaPerSecond,
				sceneIndex,
				PP_Glide.StaminaConsumptionDelay
			);
		}

		private void BodyEventsHandler(BodyEvent eventType)
		{
			if (eventType.Equals(BodyEvent.LAND) && FallHelper.IsGrounded)
			{
				Controller.ChangeState<Walk>();
			}
		}
	}
}