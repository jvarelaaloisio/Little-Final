using UnityEngine;
using System;
using UpdateManagement;
public struct DamageHandler
{
	public Action<float> onLifeChanged;
	public float maxLifePoints,
		lifePoints,
		inmunityTime;
	public bool IsInmune{ get; private set; }
	public bool IsDead => lifePoints < 0;

	public DamageHandler(float maxLifePoints, float inmunityTime, Action<float> onLifeChanged)
	{
		this.maxLifePoints = maxLifePoints;
		this.lifePoints = maxLifePoints;
		this.inmunityTime = inmunityTime;
		this.onLifeChanged = onLifeChanged;
		IsInmune = false;
	}

	#region Public
	public void TakeDamage(float damage)
	{
		if (IsInmune) return;
		IsInmune = true;
		new CountDownTimer(inmunityTime, FinishImmunity).StartTimer();
		lifePoints -= damage;
		onLifeChanged?.Invoke(lifePoints);
	}

	public void FinishImmunity()
	{
		IsInmune = false;
	}
	public void ResetLifePoints()
	{
		lifePoints = maxLifePoints;
	}
	#endregion
}
