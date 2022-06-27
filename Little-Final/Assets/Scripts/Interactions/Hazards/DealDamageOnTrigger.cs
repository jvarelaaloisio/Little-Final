using Core.LifeSystem;
using UnityEngine;

namespace Interactions.Hazards
{
	public class DealDamageOnTrigger : MonoBehaviour
	{
		[SerializeField]
		private int damage;

		private void OnTriggerEnter(Collider other)
		{
			if (!other.TryGetComponent(out IDamageable damageable))
				return;
			damageable.TakeDamage(damage);
		}
	}
}