using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Hazzard : GenericFunctions
{
	#region Variables

	#region Public

	#endregion

	#region Serialized
	[SerializeField]
	protected float damage;
	#endregion

	#region Private
	protected List<IDamageable> _damageables = new List<IDamageable>();
	#endregion

	#endregion

	#region Private
	virtual protected void Attack()
	{
		foreach (var damagable in _damageables)
		{
			damagable.TakeDamage(damage);
		}
	}
	#endregion

	#region Collisions
	private void OnTriggerExit(Collider other)
	{
		if (other.gameObject.GetComponent<IDamageable>() != null)
		{
			_damageables.Remove(other.gameObject.GetComponent<IDamageable>());
		}
	}
	protected virtual void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.GetComponent<IDamageable>() != null)
		{
			_damageables.Add(other.gameObject.GetComponent<IDamageable>());
		}
	}
	#endregion
}