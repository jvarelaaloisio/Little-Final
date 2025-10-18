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

        [Header("Debugging")]
        [SerializeField] private Debugger debugger;
        [SerializeField] private string debugTag = "StepUp";
        [SerializeField] private bool enableGizmos;
        [SerializeField, SerializeReadOnly] private bool floorIsNotTooSteep_lastValue;
        [SerializeField, SerializeReadOnly] private float heightDifferential_lastValue;
        [SerializeField, SerializeReadOnly] private bool isNotSameHeight_lastValue;

        private Rigidbody Rigidbody;
        private Vector3 _lastDirection;

        /// <inheritdoc/>
        public bool Should(Vector3 direction, IStepUp.Config configOverride = null)
        {
            _lastDirection = direction;
            configOverride ??= config;
            var feetPosition = GetFeetPosition();
            bool should = Physics.Raycast(feetPosition, direction, out var hit, configOverride.StepDistance, configOverride.StepMask);
            if (should)
                debugger.DrawLine(debugTag, feetPosition, hit.point, new Color(0.2f, 1f, 0.2f));
            else
                debugger.DrawRay(debugTag, feetPosition, direction, new Color(1, 0.2f, 0.2f));
            return should;
        }

        /// <inheritdoc/>
        public bool Can(out Vector3 stepPosition, Vector3 direction, IStepUp.Config configOverride = null)
        {
            stepPosition = Vector3.negativeInfinity;
            configOverride ??= config;
            var upScaled = transform.up * Mathf.Abs(configOverride.MaxStepHeight);
            var directionScaled = direction * configOverride.StepDistance;
            var origin = GetStepOrigin(configOverride.MaxStepHeight);
            
            if (StepUtils.HasWall(direction,
                                  origin,
                                  directionScaled,
                                  configOverride.StepDistance,
                                  configOverride.StepMask,
                                  debugger,
                                  debugTag))
                return false;

            var targetPosition = origin + directionScaled;
            if (Physics.Raycast(targetPosition, -transform.up, out var hit, configOverride.MaxDepth, configOverride.StepMask))
            {
                debugger.DrawLine(debugTag, targetPosition, hit.point, Color.green);
                stepPosition = hit.point + transform.up * distanceToFeet;
                
                bool floorIsNotTooSteep = floorIsNotTooSteep_lastValue = Vector3.Angle(transform.up, hit.normal) < maxStepFloorNormalAngle;
                float heightDifferential = heightDifferential_lastValue = Math.Abs(hit.point.y - transform.position.y + distanceToFeet);
                bool isNotSameHeight = isNotSameHeight_lastValue = heightDifferential > 0.001f;
                return isNotSameHeight && floorIsNotTooSteep;
            }
            
            debugger.DrawRay(debugTag, targetPosition, -upScaled, Color.red);
            return false;
        }

        /// <inheritdoc/>
        public void Do(Vector3 point, IStepUp.Config configOverride, Action callback = null)
            => StartCoroutine(DoCoroutine(point, configOverride, callback));

        /// <inheritdoc/>
        public IEnumerator DoCoroutine(Vector3 destination, IStepUp.Config configOverride = null, Action callback = null)
        {
            configOverride ??= config;
            yield return StepUtils.Do(transform, destination, configOverride.Duration, configOverride.StepCurve, callback);
        }
        
        private Vector3 GetStepOrigin(float maxStepHeight)
            => transform.position + transform.up * (-distanceToFeet + maxStepHeight);

        private Vector3 GetFeetPosition()
        {
            const float error = 0.01f;
            var feetPosition = transform.position;
            feetPosition.y -= distanceToFeet;
            feetPosition.y += error;
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
