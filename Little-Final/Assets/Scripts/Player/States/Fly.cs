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
			//esto está como el orto, debería
			//hacer una clase fly base y de ahi sacar esta y glide?
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
				Controller.MoveByForce(PP_Fly.Force, PP_Fly.TurnSpeed);
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
					PP_Fly.Force,
					smoothLerp
				);
			Body.SetDrag(
				Mathf.Lerp(
					PP_Glide.Drag,
					PP_Fly.Drag,
					smoothLerp
				)
			);
			Controller.view.SetAccelerationEffect(smoothLerp);
		}
	}
}