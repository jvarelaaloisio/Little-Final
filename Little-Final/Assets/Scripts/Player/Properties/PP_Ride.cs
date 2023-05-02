using UnityEngine;
using UnityEngine.Serialization;

namespace Player.Properties
{
    [CreateAssetMenu(menuName = "Properties/Player/Ride", fileName = "PP_Ride")]
    public class PP_Ride : SingletonScriptable<PP_Ride>
    {
        [SerializeField]
        private float _mountTransitionDuration;

        #region Getters

        public static float MountTransitionDuration => Instance._mountTransitionDuration;

        #endregion
    }
}