using System;
using UnityEngine;

namespace Interactables.Hazzards
{
    public class DealDamageOnCollision : MonoBehaviour
    {
        [SerializeField]
        private int damage;

        private void OnCollisionEnter(Collision collision)
        {
            if (collision.gameObject.TryGetComponent(out IDamageable damageable))
            {
                damageable.DamageHandler.TakeDamage(damage);
            }
        }
    }
}
