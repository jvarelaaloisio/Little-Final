using System;
using System.Collections;
using Core.Interactions;
using UnityEngine;

namespace Interactions.Pickable
{
    public struct BuffTarget
    {
        public float originalValue;
        public IBuffable target;
        public event Action OnReset;

        public BuffTarget(IBuffable buffable, float originalValue)
        {
            target = buffable;
            OnReset = delegate { };
            this.originalValue = originalValue;
        }
        
        public IEnumerator ResetAfter(float duration)
        {
            yield return new WaitForSeconds(duration);
            Reset();
        }
        
        public void Reset()
        {
            target.BuffMultiplier = originalValue;
            OnReset?.Invoke();
        }
    }
}