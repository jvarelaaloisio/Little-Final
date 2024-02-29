using Core.Coroutines;
using Core.Interactions;
using Core.Providers;
using Events.UnityEvents;
using UnityEngine;

namespace Interactions.Pickable
{
    public class TemporalBuff : Buff
    {
        [SerializeField] private float duration = 1;
        [SerializeField] private DataProvider<CoroutineRunner> coroutineRunnerProvider;
        
        private BuffTarget _lastBuffTarget;

        public SmartEvent onReset;

        public override void ApplyBuff(IBuffable buffable)
        {
            _lastBuffTarget = new BuffTarget(buffable, buffable.BuffMultiplier);
            _lastBuffTarget.OnReset += onReset;
            if (coroutineRunnerProvider.TryGetValue(out var runner))
            {
                const string resetAfterName = nameof(_lastBuffTarget.ResetAfter);
                runner.CancelCoroutine(resetAfterName);
                runner.RunCoroutine(_lastBuffTarget.ResetAfter(duration),
                                    resetAfterName);
            }
            else
                Debug.LogError($"{coroutineRunnerProvider.name}'s value is null!");
            
            base.ApplyBuff(buffable);
        }

        public void ResetImmediately()
        {
            if (!coroutineRunnerProvider.TryGetValue(out var runner))
            {
                return;
            }
            runner.CancelCoroutine(nameof(_lastBuffTarget));
            _lastBuffTarget.Reset();
        }
        
    }
}