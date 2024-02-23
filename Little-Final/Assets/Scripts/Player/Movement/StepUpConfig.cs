using System;
using UnityEngine;

namespace Player.Movement
{
    [Serializable]
    public class StepUpConfig
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