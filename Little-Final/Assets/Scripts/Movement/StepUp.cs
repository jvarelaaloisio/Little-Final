using System;
using System.Collections;
using Core.Attributes;
using Core.Debugging;
using Core.Movement;
using UnityEngine;

namespace Movement
{
    public class StepUp : MonoBehaviour, IStepUp
    {
        [SerializeField] private IStepUp.Config config;
        [SerializeField] private float distanceToFeet = 0.2f;
        [SerializeField] private float minStepHeight = .1f;
        [SerializeField] private float maxStepFloorNormalAngle = 30;
        [SerializeField] private bool ignoreFloorHeight = false;

        [Header("Debugging")]
        [SerializeField] private Debugger debugger;

        [SerializeField] private string debugTag = "StepUp";
        [SerializeField] private bool enableGizmos;
        [SerializeField, SerializeReadOnly] private bool floorIsNotTooSteep_lastValue;
        [SerializeField, SerializeReadOnly] private bool stepFloorIsHigherThanPlayer_lastValue;
        [SerializeField, SerializeReadOnly] private bool shouldStepUpLastValue;
        [SerializeField, SerializeReadOnly] private bool shouldStepDownLastValue;

        private Rigidbody Rigidbody;
        private Vector3 _lastDirection;

        /// <inheritdoc/>
        public bool Should(Vector3 direction, IStepUp.Config configOverride = null)
        {
            _lastDirection = direction;
            configOverride ??= config;
            return Physics.Raycast(GetFeetPosition(), direction, configOverride.StepDistance, configOverride.StepMask);
        }

        /// <inheritdoc/>
        public bool Can(out Vector3 stepPosition, Vector3 direction, IStepUp.Config configOverride = null)
        {
            stepPosition = Vector3.negativeInfinity;
            configOverride ??= config;
            var upScaled = transform.up * configOverride.MaxStepHeight;
            var directionScaled = direction * configOverride.StepDistance;
            var origin = GetStepOrigin(configOverride.MaxStepHeight);
            
            debugger.DrawRay(debugTag, origin, directionScaled, Color.black, 2f);
            if (Physics.Raycast(origin, direction, configOverride.StepDistance, configOverride.StepMask))
                return false;
            
            var targetPosition = origin + directionScaled;
            if (Physics.Raycast(targetPosition, -transform.up, out var hit, 10, configOverride.StepMask))
            {
                debugger.DrawLine(debugTag, targetPosition, hit.point, Color.green, 2f);
                stepPosition = hit.point + transform.up * distanceToFeet;
                
                var floorIsNotTooSteep = Vector3.Angle(transform.up, hit.normal) < maxStepFloorNormalAngle;
                var stepFloorIsHigherThanPlayer = hit.point.y > transform.position.y - distanceToFeet + minStepHeight;
                return (stepFloorIsHigherThanPlayer || ignoreFloorHeight) && floorIsNotTooSteep;
            }
            
            debugger.DrawRay(debugTag, targetPosition, -upScaled, Color.black, 2f);
            return false;
        }

        /// <inheritdoc/>
        public void Do(Vector3 point, IStepUp.Config configOverride, Action callback = null)
            => StartCoroutine(DoCoroutine(point, configOverride, callback));

        /// <inheritdoc/>
        public IEnumerator DoCoroutine(Vector3 destination, IStepUp.Config configOverride = null, Action callback = null)
        {
            configOverride ??= config;
            var origin = transform.position;
            var beginning = Time.time;
            float now = 0;
            do
            {
                now = Time.time;
                var lerp = (now - beginning) / configOverride.Duration;
                transform.position = Vector3.Lerp(origin, destination, configOverride.StepCurve.Evaluate(lerp));

                yield return null;
            } while (now < beginning + configOverride.Duration);

            transform.position = destination;
            callback?.Invoke();
        }

        private Vector3 GetStepOrigin(float maxStepHeight)
            => transform.position + transform.up * (-distanceToFeet + maxStepHeight);

        private Vector3 GetFeetPosition()
        {
            var feetPosition = transform.position;
            feetPosition.y -= distanceToFeet;
            return feetPosition;
        }

        private void OnDrawGizmosSelected()
        {
            if (!enableGizmos)
                return;
            var origin = GetStepOrigin(config.MaxStepHeight);
            var upScaled = transform.up * config.MaxStepHeight;
            var forwardScaled = _lastDirection * config.StepDistance;
            Gizmos.color = Color.green;
            Gizmos.DrawRay(origin, forwardScaled);
            Gizmos.color = Color.red;
            Vector3 targetPosition = origin + forwardScaled;
            Gizmos.DrawRay(targetPosition, -upScaled);
            Gizmos.color = Color.blue;
            Gizmos.DrawRay(transform.position, -transform.up * distanceToFeet);
            Gizmos.color = Color.gray;
            Gizmos.DrawRay(GetFeetPosition(), forwardScaled);
        }
    }
}
