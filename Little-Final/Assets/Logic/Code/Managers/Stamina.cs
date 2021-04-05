using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
using System;
public class Stamina
{
	private readonly float _refillSpeed;
	private float _fillState;
	public float FillState
	{
		get => _fillState;
		private set
		{
			onStaminaChange?.Invoke(value);
			_fillState = Mathf.Clamp(value, 0, maxStamina);
		}
	}

	public bool IsRefillingActive => isRefillingActive;
	public float MaxStamina => maxStamina;

	public float RefillSpeed => _refillSpeed;


	private readonly Action onRefillingStart;
	private readonly Action<float> onStaminaChange;
	private readonly CountDownTimer refillDelayTimer;
	private readonly CountDownTimer refillPeriod;
	private float maxStamina;
	private bool isRefillingActive = true;
	public Stamina(
		float maxStamina,
		float refillDelay,
		float refillSpeed,
		int sceneIndex,
		Action<float> onStaminaChange = null,
		Action onRefillingStart = null)
	{
		_refillSpeed = refillSpeed;
		this.maxStamina = maxStamina;
		FillState = maxStamina;
		this.onStaminaChange = onStaminaChange;
		this.onRefillingStart = onRefillingStart;
		refillDelayTimer = new CountDownTimer(refillDelay, StartRefill, sceneIndex);
		refillPeriod = new CountDownTimer(1 / refillSpeed, RefillStamina, sceneIndex);
	}
	private void RefillStamina()
	{
		FillState++;
		if (FillState < maxStamina)
			refillPeriod.StartTimer();
	}
	private void StartRefill()
	{
		onRefillingStart?.Invoke();
		refillPeriod.StartTimer();
	}
	public void ConsumeStamina(float value)
	{
		if (value == 0)
			return;
		FillState -= value;
		refillPeriod.StopTimer();
		if (isRefillingActive)
			refillDelayTimer.StartTimer();
	}
	public void StopFilling()
	{
		refillPeriod.StopTimer();
		isRefillingActive = false;
	}
	public void ResumeFilling()
	{
		refillDelayTimer.StartTimer();
		isRefillingActive = true;
	}
	public void RefillCompletely()
	{
		FillState = maxStamina;
	}
	public void UpgradeMaxStamina(float value)
	{
		maxStamina = value;
		refillPeriod.StartTimer();
	}
}
