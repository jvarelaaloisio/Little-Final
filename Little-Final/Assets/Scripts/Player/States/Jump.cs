using CharacterMovement;
using Core.Extensions;
using Core.Gameplay;
using Core.Helpers.Movement;
using Core.Interactions;
using Player.Movement;
using Player.PlayerInput;
using Player.Properties;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Jump : State
	{

		private const float MIN_TIME_BEFORE_GLIDE = .1f;
		private bool _canGlide = false;

		private CountDownTimer _waitBeforeGlide;
		
		public override void OnStateEnter(PlayerController controller, IInputReader inputReader, int sceneIndex)
		{
			base.OnStateEnter(controller, inputReader, sceneIndex);
			MyTransform = controller.transform;

			if (PP_Jump.LoseItem && Controller.HasItem())
				Controller.PutDownItem();
			
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
			float currentSpeed = PP_Jump.Speed;
			if (MoveHelper.IsApproachingWall(MyTransform,
											PP_Jump.AwareDistance,
											PP_Jump.Walls,
											out var hit))
			{
				Debug.DrawLine(MyTransform.position, hit.point, Color.blue);

				currentSpeed = Mathf.Lerp(0, PP_Jump.Speed, hit.distance / PP_Jump.AwareDistance);
			}

			Vector2 input = InputManager.GetHorInput();
			Vector3 direction = MoveHelper.GetDirection(input);
			MoveHelper.Rotate(MyTransform, direction, PP_Jump.TurnSpeedInTheAir);
			Body.RequestMovement(new MovementRequest(MyTransform.forward * input.magnitude, currentSpeed, currentSpeed));

			CheckForJumpBuffer();
			CheckClimb();
			if (Controller.StepUp != null && Controller.StepUp.Can(out var stepPosition, MyTransform.forward, PP_Jump.StepUpConfig))
			{
				Controller.StepUp.StepUp(PP_Jump.StepUpConfig, stepPosition, () => Controller.ChangeState<Walk_OLD>());
				Controller.ChangeState<Void>();
			}
			Controller.RunAbilityList(Controller.AbilitiesInAir);
			CheckGlide();

			if (InputManager.CheckInteractInput()
				&& Controller.CanMount(out var interactable)
				&& interactable is IRideable)
			{
				Controller.Rideable = interactable;
				Controller.ChangeState<Mount>();
			}
		}
		
		public override void OnStateExit()
		{
			//-- Deberia irse cuando refactorice para que el controller haga los cambios
			_waitBeforeGlide.StopTimer();
			//-- A glide
			Controller.OnGlideChanges(false);
			Body.RequestMovement(MovementRequest.InvalidRequest);
			Body.BodyEvents -= BodyEventsHandler;
		}

		private void BodyEventsHandler(BodyEvent eventType)
		{
			if (eventType.Equals(BodyEvent.LAND)
				&& FallHelper.IsGrounded)
				Controller.ChangeState<Walk_OLD>();
		}

		//-- A Glide
		protected virtual void CheckGlide()
		{
			if (_canGlide
				&& InputManager.GetGlideInput()
				&& !(Controller.Stamina.Current < 1)
				&& !(Body.Velocity.y > 0))
				Controller.ChangeState<Glide>();
		}
	}
}