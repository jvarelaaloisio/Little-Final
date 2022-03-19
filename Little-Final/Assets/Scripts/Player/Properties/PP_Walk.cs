using UnityEngine;
using UnityEngine.Serialization;

namespace Player.Properties
{
    [CreateAssetMenu(menuName = "Properties/Player/Walk", fileName = "PP_Walk")]
    public class PP_Walk : SingletonScriptable<PP_Walk>
    {
        [SerializeField] [Range(0, 100, step: .5f)]
        private float speed;

        [SerializeField] [Range(0, 100, step: .5f)]
        private float turnSpeed;

        [SerializeField] [Range(0, 100, step: .5f)]
        private float runSpeed;

        [SerializeField] [Range(0, 100, step: .5f)]
        private float runStaminaPerSecond;

        [SerializeField] [Range(0, 90, step: 1)]
        private float minSafeAngle;

        #region Getters

        public float Speed => speed;
        public float TurnSpeed => turnSpeed;
        public float MinSafeAngle => minSafeAngle;
        public float RunSpeed => runSpeed;
        public float RunStaminaPerSecond => runStaminaPerSecond;

        #endregion
    }
}