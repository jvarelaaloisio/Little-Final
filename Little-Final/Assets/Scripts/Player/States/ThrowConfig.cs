using UnityEngine;

namespace Player.States
{
    [CreateAssetMenu(menuName = "Models/Player/Throw Config", fileName = "ThrowConfig", order = 0)]
    public class ThrowConfig : ScriptableObject
    {
        [field: SerializeField] public float Duration { get; set; } = 1f;
        [field: SerializeField] public Vector3 Force { get; set; } = Vector3.forward;
    }
}