using Core.Stamina;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.Stamina
{
	public class StaminaConsumer
	{
		private readonly IStamina _target;
		private readonly ActionWithFrequency _consumingStamina;
		private readonly CountDownTimer _waitToConsumeStamina;
		private readonly float _consumptionDelay;
		public bool IsConsuming => _consumingStamina.IsRunning;

		public StaminaConsumer(
			IStamina target,
			float staminaPerSecond,
			int sceneIndex,
			float consumptionDelay = 0)
		{
			_target = target;
			_consumptionDelay = consumptionDelay;
			_consumingStamina
				= new ActionWithFrequency(
					ConsumeStamina,
					staminaPerSecond,
					sceneIndex
				);
			if (consumptionDelay != 0)
				_waitToConsumeStamina
					= new CountDownTimer(
						consumptionDelay,
						_consumingStamina.StartAction,
						sceneIndex
					);
		}

		public void Start()
		{
			if (_consumptionDelay != 0
			    && !_waitToConsumeStamina.IsTicking)
				_waitToConsumeStamina.StartTimer();
			else
				_consumingStamina.StartAction();
		}

		public void Stop()
		{
			if (_consumptionDelay != 0)
				_waitToConsumeStamina.StopTimer();
			_consumingStamina.StopAction();
		}

		private void ConsumeStamina()
		{
			_target.Consume(1);
		}
	}
}