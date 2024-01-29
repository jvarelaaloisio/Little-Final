using Events.UnityEvents;
using HealthSystem.Runtime.Components;
using UnityEngine;

namespace Health
{
    public class HealthComponentWithSimpleEvents : HealthComponent
    {
        [SerializeField] public SmartEvent onDeath = new();
        [SerializeField] public IntSmartEvent onHeal = new();
        [SerializeField] public IntSmartEvent onDamage;

        public override void Setup()
        {
            base.Setup();
            Health.OnDeath += onDeath.Invoke;
            Health.OnHeal += HandleHeal;
            Health.OnDamage += HandleDamage;
        }

        private void HandleDamage(int before, int after) => onDamage.Invoke(after);

        private void HandleHeal(int before, int after) => onHeal.Invoke(after);
    }
}