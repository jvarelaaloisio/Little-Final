using UnityEngine;

public delegate void Damage_Events(float life);
public class DamageHandler : GenericFunctions, IDamageable
{
	#region Variables

	#region Public
	public event Damage_Events LifeChangedEvent;
	#endregion

	#region Serialized
	[SerializeField]
	float lifePoints,
		inmunityTime;
	#endregion

	#region Private
	Timer_DEPRECATED _inmunityTimer;
	#endregion

	#region Getters
	public bool IsInmune { get; private set; }
	#endregion
	#endregion

	#region Unity
	private void Start()
	{
		_inmunityTimer = SetupTimer(inmunityTime, "Inmunity Timer");
	}
	#endregion

	#region Private
	protected override void TimerFinishedHandler(string ID)
	{
		IsInmune = false;
	}
	#endregion

	#region Public
	public void TakeDamage(float damage)
	{
		if (IsInmune) return;
		IsInmune = true;
		if (!_inmunityTimer.Counting)
		{
			_inmunityTimer.Play();
			//_inmunityTimer.GottaCount = true;
		}
		lifePoints -= damage;
		LifeChangedEvent?.Invoke(lifePoints);
	}

	public void FinishInmunity()
	{
		IsInmune = false;
	}
	#endregion
}
