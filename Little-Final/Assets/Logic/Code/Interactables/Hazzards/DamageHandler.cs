using System;
using VarelaAloisio.UpdateManagement.Runtime;

public struct DamageHandler
{
	public Action<float> onLifeChanged;
	private readonly int _sceneIndex;

	public float maxLifePoints,
		lifePoints,
		ImmunityTime;
	public bool IsImmune{ get; private set; }
	public bool IsDead => lifePoints < 0;

	public DamageHandler(
		float maxLifePoints,
		float immunityTime,
		Action<float> onLifeChanged,
		int sceneIndex)
	{
		this.maxLifePoints = maxLifePoints;
		lifePoints = maxLifePoints;
		ImmunityTime = immunityTime;
		this.onLifeChanged = onLifeChanged;
		_sceneIndex = sceneIndex;
		IsImmune = false;
	}

	#region Public
	public void TakeDamage(float damage)
	{
		if (IsImmune) return;
		IsImmune = true;
		new CountDownTimer(ImmunityTime, FinishImmunity, _sceneIndex).StartTimer();
		lifePoints -= damage;
		onLifeChanged?.Invoke(lifePoints);
	}

	public void FinishImmunity()
	{
		IsImmune = false;
	}
	public void ResetLifePoints()
	{
		lifePoints = maxLifePoints;
	}
	#endregion
}
