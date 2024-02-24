using System;
using System.Collections;
using Core.Debugging;
using UnityEngine;

namespace Player.Movement
{
    public class StepUpBehaviour : MonoBehaviour, IStepUp
    {
        [SerializeField] private StepUpConfig config;
        [SerializeField] private Vector3 offset;
        [SerializeField] private float distanceToFeet = 0.2f;
        [SerializeField] private float minStepHeight = .1f;
        [SerializeField] private float maxStepFloorNormalAngle = 30;


        [Header("Debugging")]
        [SerializeField] private Debugger debugger;

        [SerializeField] private string debugTag = "StepUp";


        public bool Can(out Vector3 stepPosition, Vector3 direction, StepUpConfig configOverride = null)
        {
            stepPosition = Vector3.negativeInfinity;
            configOverride ??= config;
            var upScaled = transform.up * configOverride.MaxStepHeight;
            var directionScaled = direction * configOverride.StepDistance;
            var origin = GetStepOrigin(configOverride.MaxStepHeight);
            
            debugger.DrawRay(debugTag, origin, directionScaled, Color.gray);
            if (Physics.Raycast(origin, direction, configOverride.StepDistance, configOverride.StepMask))
                return false;
            
            var targetPosition = origin + directionScaled;
            if (Physics.Raycast(targetPosition, -transform.up, out var hit, configOverride.MaxStepHeight, configOverride.StepMask))
            {
                debugger.DrawLine(debugTag, targetPosition, hit.point, Color.green);
                stepPosition = hit.point + transform.up * distanceToFeet;
                
                var floorIsNotTooSteep = Vector3.Angle(transform.up, hit.normal) < maxStepFloorNormalAngle;
                var stepFloorIsHigherThanPlayer = hit.point.y > transform.position.y - distanceToFeet + minStepHeight;
                return stepFloorIsHigherThanPlayer && floorIsNotTooSteep;
            }
            
            debugger.DrawRay(debugTag, targetPosition, -upScaled, Color.gray);
            return false;
        }

        public void StepUp(StepUpConfig configOverride, Vector3 point, Action callback = null)
        {
            StartCoroutine(StepUpCoroutine(configOverride, point, callback));
        }

        public IEnumerator StepUpCoroutine(StepUpConfig configOverride, Vector3 destination, Action callback = null)
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
        {
            return transform.position + transform.up * (-distanceToFeet + maxStepHeight);
        }

        private void OnDrawGizmosSelected()
        {
            // var origin = transform.position + offset;
            var origin = GetStepOrigin(config.MaxStepHeight);
            var upScaled = transform.up * config.MaxStepHeight;
            var forwardScaled = transform.forward * config.StepDistance;
            Gizmos.color = Color.green;
            Gizmos.DrawRay(origin, forwardScaled);
            Gizmos.color = Color.red;
            Vector3 targetPosition = origin + forwardScaled;
            Gizmos.DrawRay(targetPosition, -upScaled);
            Gizmos.color = Color.blue;
            Gizmos.DrawRay(transform.position, -transform.up * distanceToFeet);
        }
    }
}
