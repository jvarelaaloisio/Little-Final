using Core.Interactions;
using UnityEngine;

namespace Interactions.Pickable
{
    public class Buff : MonoBehaviour
    {
        [SerializeField] protected float multiplier;

        public virtual bool TryToApplyBuffOn(Transform target, out IBuffable buffable)
        {
            buffable = target.GetComponent<IBuffable>();
            if (buffable == null)
                return false;
            ApplyBuff(buffable);
            return true;
        }

        public bool TryGetBuffable(Transform target, out IBuffable buffable)
        {
            buffable = target.GetComponent<IBuffable>();
            return buffable != null;
        }

        public virtual void ApplyBuff(IBuffable buffable)
        {
            buffable.BuffMultiplier = multiplier;
        }
    }
}
