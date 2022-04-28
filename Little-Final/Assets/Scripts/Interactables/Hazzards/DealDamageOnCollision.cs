using UnityEngine;

namespace Interactables.Hazards
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
