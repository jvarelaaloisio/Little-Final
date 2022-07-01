using CharacterMovement;
using Core.Interactions;
using Player.PlayerInput;
using Player.Properties;
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
			float currentSpeed = PP_Jump.Speed;
			if (MoveHelper.IsApproachingWall(MyTransform,
											PP_Jump.AwareDistance,
											PP_Jump.Walls,
											out var hit))
			{
				Debug.DrawLine(MyTransform.position, hit.point, Color.blue);

				currentSpeed = Mathf.Lerp(0, PP_Jump.Speed, hit.distance / PP_Jump.AwareDistance);
			}

			//TODO: Delete this and only use moveByForce once the movement tests are finished
			if (Input.GetKey(KeyCode.RightControl))
			{
				MoveHorizontally(Body, PP_Jump.JumpSpeed, PP_Jump.TurnSpeedInTheAir);
			}
			else
			{
				Vector2 input = InputManager.GetHorInput();
				Vector3 direction = MoveHelper.GetDirection(input);
				MoveHelper.Rotate(MyTransform, direction, PP_Jump.TurnSpeedInTheAir);
				Body.RequestMovement(new MovementRequest(MyTransform.forward * input.magnitude, currentSpeed));
			}

			CheckForJumpBuffer();
			CheckClimb();
			Controller.RunAbilityList(Controller.AbilitiesInAir);
			CheckGlide();

			if (InputManager.CheckInteractInput()
				&& Controller.CanMount(out var interactable)
				&& interactable is IRideable)
			{
				IRideable rideable = (IRideable) interactable;
				Controller.Mount(rideable);
				Controller.ChangeState<Ride>();
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