using System;
using Core.Stamina;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.Stamina
{
	public class Stamina : IStamina
	{
		public event Action OnRefilling;
		public event Action OnRefilled;
		public event Action<float> OnUpgrade; 
		public event ValueChangeEvent OnChange;
		private readonly CountDownTimer _refillDelayTimer;
		private readonly CountDownTimer _refillPeriod;
		private float _current;

		public float Current
		{
			get => _current;
			private set
			{
				var old = _current;
				_current = Mathf.Clamp(value, 0, Max);
				OnChange?.Invoke(old, value, Max);
			}
		}

		public bool CanRefill { get; private set; } = true;

		public float Max { get; private set; }

		public float RefillSpeed { get; }

		public Stamina(
			float max,
			float refillDelay,
			float refillSpeed,
			int sceneIndex)
		{
			if (refillSpeed <= 0)
				throw new ArgumentException("RefillSpeed must be > 0", nameof(refillSpeed));
			RefillSpeed = refillSpeed;
			Max = max;
			Current = max;
			_refillDelayTimer = new CountDownTimer(refillDelay, StartRefill, sceneIndex);
			_refillPeriod = new CountDownTimer(1 / refillSpeed, Refill, sceneIndex);
		}

		public void Consume(float value)
		{
			if (value == 0)
				return;
			Current -= value;
			_refillPeriod.StopTimer();
			if (CanRefill)
				_refillDelayTimer.StartTimer();
		}

		public void StopRefilling()
		{
			_refillPeriod.StopTimer();
			CanRefill = false;
			OnRefilled?.Invoke();
		}

		public void ResumeRefilling()
		{
			_refillDelayTimer.StartTimer();
			CanRefill = true;
			OnRefilling?.Invoke();
		}

		public void RefillCompletely()
			=> Current = Max;

		public void UpgradeMax(float value)
		{
			Max = value;
			_refillPeriod.StartTimer();
			OnUpgrade?.Invoke(Max);
		}

		private void StartRefill()
		{
			_refillPeriod.StartTimer();
			OnRefilling?.Invoke();
		}

		private void Refill()
		{
			Current++;
			if (Current < Max)
				_refillPeriod.StartTimer();
		}
	}
}
