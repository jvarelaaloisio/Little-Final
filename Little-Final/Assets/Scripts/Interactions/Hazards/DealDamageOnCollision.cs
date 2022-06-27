using Core.LifeSystem;
using UnityEngine;

namespace Interactions.Hazards
{
    public class DealDamageOnCollision : MonoBehaviour
    {
        [SerializeField]
        private int damage;

        private void OnCollisionEnter(Collision collision)
        {
            //TODO:Get rid of the damageHandler
            if (collision.gameObject.TryGetComponent(out IDamageHandler damageHandler))
            {
                damageHandler.DamageHandler.TakeDamage(damage);
            }
            else if (collision.gameObject.TryGetComponent(out IDamageable damageable))
            {
                damageable.TakeDamage(damage);
            }
        }
    }
}
