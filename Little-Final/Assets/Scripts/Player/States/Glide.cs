using CharacterMovement;
using Core.Extensions;
using Core.Gameplay;
using Core.Interactions;
using Player.PlayerInput;
using Player.Properties;
using Player.Stamina;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Glide : State
	{
		protected StaminaConsumer Consumer;
		protected CountDownTimer SetFlight;
		private ActionOverTime pushPlayerUp;
		private ForceRequest _gravitySimulation;
		private float _originalDrag;
		
		public override void OnStateEnter(PlayerController controller, IInputReader inputReader, int sceneIndex)
		{
			base.OnStateEnter(controller, inputReader, sceneIndex);
			Body.BodyEvents += BodyEventsHandler;
			
			if (PP_Glide.LoseItem && Controller.HasItem())
				Controller.PutDownItem();
			
			controller.OnGlideChanges(true);
			_originalDrag = Body.Drag;
			Body.Drag = PP_Glide.Drag;
			Body.RigidBody.useGravity = false;
			_gravitySimulation = new ForceRequest(Physics.gravity * PP_Glide.GravityMultiplier, ForceMode.Force);
			Body.RequestConstantForce(_gravitySimulation);

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
			    || Controller.Stamina.Current < 1
			    || Body.Velocity.y > 0)
				Controller.ChangeState<Jump>();

			CheckClimb();

			if (Controller.StepUp != null && Controller.StepUp.Can(out var stepPosition, MyTransform.forward, PP_Glide.StepUpConfig))
			{
				Controller.StepUp.Do(stepPosition,
				                     PP_Glide.StepUpConfig,
				                     () => Controller.ChangeState<Walk_OLD>());
				Controller.ChangeState<Void>();
			}
			
			CheckForJumpBuffer();
			Controller.RunAbilityList(Controller.AbilitiesInAir);
			
			if (InputManager.CheckInteractInput()
				&& Controller.CanMount(out IRideable interactable)
				&& interactable is IRideable)
			{
				Controller.Rideable = interactable;
				Controller.ChangeState<Mount>();
			}
		}

		public override void OnStateExit()
		{
			Controller.OnGlideChanges(false);
			Consumer.Stop();
			SetFlight.StopTimer();
			Body.RequestMovement(MovementRequest.InvalidRequest);
			Body.BodyEvents -= BodyEventsHandler;
			Body.CancelConstantForce(_gravitySimulation);
			Body.Drag = _originalDrag;
			Body.RigidBody.useGravity = true;
		}

		protected virtual void Move()
		{
			Vector2 input = InputManager.GetHorInput();
			Vector3 direction = MoveHelper.GetDirection(input);
			if (Vector3.Dot(direction.normalized, MyTransform.forward) < -.5f)
			{
				Body.RequestMovement(new MovementRequest(-Body.Velocity.IgnoreY(), .25f, .25f));
			}
			else
			{
				MoveHelper.Rotate(MyTransform, direction, PP_Glide.TurnSpeed);
				Body.RequestMovement(new MovementRequest(MyTransform.forward, PP_Glide.Speed * direction.magnitude, PP_Glide.Acceleration));
			}

			Controller.OnChangeSpeed(Body.Velocity.IgnoreY().magnitude);
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
				Controller.ChangeState<Walk_OLD>();
			}
		}
	}
}