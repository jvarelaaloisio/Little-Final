using CharacterMovement;
using Player.PlayerInput;
using Player.Properties;
using Player.Stamina;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Fly : Glide
	{
		private float _initialSpeed;
		private float _currentSpeed;
		private ActionOverTime _accelerate;

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			_initialSpeed = Body.Velocity.magnitude;
			_accelerate
				= new ActionOverTime(
					PP_Fly.AccelerationTime,
					Accelerate,
					sceneIndex,
					true
				);
			_accelerate.StartAction();
			controller.view.ShowAccelerationFeedback();
			//TODO: esto está como el orto, debería haber una clase fly base y de ahi sacar esta y glide?
			SetFlight.StopTimer();
		}

		public override void OnStateExit()
		{
			_accelerate.StopAction();
			Controller.view.StopAccelerationFeedback();
			base.OnStateExit();
		}

		protected override void Move()
		{
			//TODO: Delete this and only use moveByForce once the movement tests are finished
			if (Input.GetKey(KeyCode.RightControl))
			{
				MoveHorizontally(Body, 10, PP_Fly.TurnSpeed);
			}
			else
			{
				Vector2 input = InputManager.GetHorInput();
				Vector3 direction = MoveHelper.GetDirection(input);
				MoveHelper.Rotate(MyTransform, direction, PP_Fly.TurnSpeed);
				//TODO: Change 4 for editable variable in pp_fly
				Body.RequestMovement(new MovementRequest(MyTransform.forward, PP_Fly.Speed, PP_Fly.Acceleration));
			}
		}

		protected override void SetupConsumer(int sceneIndex)
		{
			Consumer = new StaminaConsumer(
				Controller.Stamina,
				PP_Fly.StaminaPerSecond,
				sceneIndex,
				PP_Fly.StaminaConsumptionDelay
			);
		}

		private void Accelerate(float lerp)
		{
			var smoothLerp = BezierHelper.GetSinBezier(lerp);
			_currentSpeed
				= Mathf.Lerp(
					_initialSpeed,
					PP_Fly.Acceleration,
					smoothLerp
				);
			Controller.view.SetAccelerationEffect(smoothLerp);
		}
	}
}