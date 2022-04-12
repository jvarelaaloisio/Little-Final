using UnityEngine;
using UnityEngine.Serialization;

namespace Player.Properties
{
    //TODO:Refactor these scriptables to unify the movement properties (in a single class) and therefore simplify the code
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

        [SerializeField] [Range(0, 10, step: .5f)]
        private float throwForce;

        #region Getters

        public static float Speed => Instance.speed;
        public static float TurnSpeed => Instance.turnSpeed;
        public static float MinSafeAngle => Instance.minSafeAngle;
        public static float RunSpeed => Instance.runSpeed;
        public static float RunStaminaPerSecond => Instance.runStaminaPerSecond;
        public static float ThrowForce => Instance.throwForce;

        #endregion
    }
}