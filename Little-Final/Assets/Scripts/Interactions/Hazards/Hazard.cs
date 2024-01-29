using System;
using System.Collections.Generic;
using UnityEngine;

namespace Interactions.Hazards
{
	[Obsolete]
	public abstract class Hazard : MonoBehaviour
	{
		#region Variables

		#region Serialized
		[SerializeField]
		protected float damage;
		#endregion

		#region Private
		protected List<IDamageHandler> _damageables = new List<IDamageHandler>();
		#endregion

		#endregion

		#region Private
		virtual protected void Attack()
		{
			foreach (var damagable in _damageables)
			{
				damagable.DamageHandler.TakeDamage(damage);
			}
		}
		#endregion

		#region Collisions
		protected virtual void OnTriggerExit(Collider other)
		{
			if (other.gameObject.GetComponent<IDamageHandler>() != null)
			{
				_damageables.Remove(other.gameObject.GetComponent<IDamageHandler>());
			}
		}
		protected virtual void OnTriggerEnter(Collider other)
		{
			if (other.gameObject.TryGetComponent<IDamageHandler>(out IDamageHandler damageable))
			{
				_damageables.Add(damageable);
			}
		}
		#endregion
	}
}