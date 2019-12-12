using UnityEngine;

public delegate void Damage_Events(float life);
public class Damage_Handler : GenericFunctions, IDamageable
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
	Timer _inmunityTimer;
	bool isInmune;
	#endregion

	#region Getters
	public bool IsInmune
	{
		get
		{
			return isInmune;
		}
	}
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
		isInmune = false;
	}
	#endregion

	#region Public
	public void TakeDamage(float damage)
	{
		if (isInmune) return;
		isInmune = true;
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
		isInmune = false;
	}
	#endregion
}
