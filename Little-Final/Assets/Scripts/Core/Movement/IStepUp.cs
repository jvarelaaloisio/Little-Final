using System;
using System.Collections;
using UnityEngine;

namespace Core.Movement
{
    public interface IStepUp
    {
        bool Should(Vector3 direction, Config configOverride = null);
        bool Can(out Vector3 stepPosition, Vector3 direction, Config configOverride = null);
        void StepUp(Config configOverride, Vector3 point, Action callback = null);
        IEnumerator StepUpCoroutine(Config configOverride, Vector3 destination, Action callback = null);
        
        [Serializable]
        public class Config
        {
            [field: SerializeField]
            [field: Range(0, 2, .05f)]
            public float MaxStepHeight { get; set; } = .05f;

            [field: SerializeField]
            [field: Range(0, 5, .05f)]
            public float StepDistance { get; set; } = .2f;

            [field: SerializeField]
            [field: Range(0, 2, .05f)]
            public float Duration { get; set; } = .1f;

            [field: SerializeField]
            public LayerMask StepMask { get; set; }
        
            [field: SerializeField]
            public AnimationCurve StepCurve { get; set; } = AnimationCurve.EaseInOut(0, 0, 1, 1);
        }
    }
}