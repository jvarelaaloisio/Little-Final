using System;
using System.Threading;
using Core.Attributes;
using Core.References;
using Core.Stamina;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace StaminaAsync
{
	[Serializable]
	public class Stamina : IStamina, IDisposable, ISetup
	{
		/// <inheritdoc />
		[field: SerializeField] public float Max { get; private set; } = 100;

		/// <inheritdoc />
		[field: Range(0.1f, 100f)]
		[field: SerializeField] public float RefillSpeed { get; private set; } = 60;

		[field: SerializeField] public float RefillDelay { get; private set; } = 1.5f;

		private float _current;
		private CancellationTokenSource _refillSource;

		/// <inheritdoc />
		public event Action OnRefilling;

		/// <inheritdoc />
		public event Action OnRefilled;

		/// <inheritdoc />
		public event ValueChangeEvent OnChange;

		/// <inheritdoc />
		public event Action<float> OnUpgrade;

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

		/// <inheritdoc />
		public bool CanRefill { get; private set; } = true;

		/// <inheritdoc />
		public void Setup()
		{
			_current = Max;
		}

		/// <inheritdoc />
		public void Consume(float value)
		{
			if (value == 0)
				return;
			Current -= value;
			CancelRefillTask();
			if (CanRefill)
				StartRefillingTask();
		}

		/// <inheritdoc />
		public void StopRefilling()
		{
			CancelRefillTask();
			CanRefill = false;
			OnRefilled?.Invoke();
		}

		public void ResumeRefilling()
		{
			if (!_refillSource?.IsCancellationRequested ?? false)
				CancelRefillTask();
			StartRefillingTask();
		}

		/// <inheritdoc />
		public void RefillCompletely()
			=> Current = Max;

		/// <inheritdoc />
		public void UpgradeMax(float value)
		{
			Max = value;
			CancelRefillTask();
			StartRefillingTask();
			OnUpgrade?.Invoke(Max);
		}

		/// <inheritdoc />
		public void Dispose()
		{
			_refillSource?.Dispose();
		}

		private void StartRefillingTask()
		{
			_refillSource = new CancellationTokenSource();
			Refill(_refillSource.Token).Forget();
		}

		private async UniTaskVoid Refill(CancellationToken token)
		{
			if (RefillDelay > 0)
				await UniTask.WaitForSeconds(RefillDelay, cancellationToken: token);

			OnRefilling?.Invoke();
			while (!token.IsCancellationRequested && Current < Max)
			{
				Current++;
				await UniTask.WaitForSeconds(1 / RefillSpeed, cancellationToken: token);
			}
			OnRefilled?.Invoke();
		}

		private void CancelRefillTask()
		{
			_refillSource?.Cancel();
			_refillSource?.Dispose();
			_refillSource = null;
		}
	}
}
