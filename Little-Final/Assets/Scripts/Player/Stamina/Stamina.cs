using System;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.Stamina
{
	public class Stamina
	{
		private float _fillState;
		public float FillState
		{
			get => _fillState;
			private set
			{
				OnStaminaChange?.Invoke(value);
				_fillState = Mathf.Clamp(value, 0, _maxStamina);
			}
		}

		public bool IsRefillingActive => _isRefillingActive;
		public float MaxStamina => _maxStamina;

		public float RefillSpeed { get; }


		public Action OnRefillingStart;
		public Action<float> OnStaminaChange;
		private readonly CountDownTimer _refillDelayTimer;
		private readonly CountDownTimer _refillPeriod;
		private float _maxStamina;
		private bool _isRefillingActive = true;
		public Stamina(
			float maxStamina,
			float refillDelay,
			float refillSpeed,
			int sceneIndex)
		{
			RefillSpeed = refillSpeed;
			_maxStamina = maxStamina;
			FillState = maxStamina;
			_refillDelayTimer = new CountDownTimer(refillDelay, StartRefill, sceneIndex);
			_refillPeriod = new CountDownTimer(1 / refillSpeed, RefillStamina, sceneIndex);
		}
		private void RefillStamina()
		{
			FillState++;
			if (FillState < _maxStamina)
				_refillPeriod.StartTimer();
		}
		private void StartRefill()
		{
			OnRefillingStart?.Invoke();
			_refillPeriod.StartTimer();
		}
		public void ConsumeStamina(float value)
		{
			if (value == 0)
				return;
			FillState -= value;
			_refillPeriod.StopTimer();
			if (_isRefillingActive)
				_refillDelayTimer.StartTimer();
		}
		public void StopRefilling()
		{
			_refillPeriod.StopTimer();
			_isRefillingActive = false;
		}
		public void ResumeRefilling()
		{
			_refillDelayTimer.StartTimer();
			_isRefillingActive = true;
		}
		public void RefillCompletely()
		{
			FillState = _maxStamina;
		}
		public void UpgradeMaxStamina(float value)
		{
			_maxStamina = value;
			_refillPeriod.StartTimer();
		}
	}
}
