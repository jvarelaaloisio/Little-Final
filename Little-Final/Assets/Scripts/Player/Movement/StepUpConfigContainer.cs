using UnityEngine;

namespace Player.Movement
{
    [CreateAssetMenu(menuName = "Models/Movement/Step Up Config", fileName = "StepUpConfig", order = 0)]
    public class StepUpConfigContainer : ScriptableObject
    {
        [field:SerializeField] public StepUpConfig Config { get; set; }

        public float MaxStepHeight => Config.MaxStepHeight;
        public float StepDistance => Config.StepDistance;
        public float Duration => Config.Duration;
        public LayerMask StepMask => Config.StepMask;
        
        public static implicit operator StepUpConfig(StepUpConfigContainer origin) => origin.Config;
    }
}