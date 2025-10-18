using System;
using System.Collections;
using Core.Attributes;
using Core.Debugging;
using Core.Movement;
using UnityEngine;

namespace Movement
{
	public class StepDown : MonoBehaviour, IStepDown
	{
		[SerializeField] private IStepDown.Config config;
		[SerializeField] private float distanceToFeet = 0.2f;
		[SerializeField] private float minStepHeight = .1f;
		[SerializeField] private float maxStepFloorNormalAngle = 30;
		[SerializeField] private bool ignoreFloorHeight = false;

		[Header("Debugging")]
		[SerializeField] private Debugger debugger;
		[SerializeField] private string debugTag = "StepDown";
		[SerializeField] private bool enableGizmos;
		[SerializeField, SerializeReadOnly] private bool floorIsNotTooSteep_lastValue;
		[SerializeField, SerializeReadOnly] private bool stepFloorIsHigherThanPlayer_lastValue;
		[SerializeField, SerializeReadOnly] private bool shouldStepUpLastValue;
		[SerializeField, SerializeReadOnly] private bool shouldStepDownLastValue;

		private Rigidbody Rigidbody;
		private Vector3 _lastDirection;

		/// <inheritdoc/>
		public bool Can(out Vector3 stepPosition, Vector3 direction, IStepDown.Config configOverride = null)
		{
			stepPosition = Vector3.negativeInfinity;
			configOverride ??= config;
			var downScaled = -transform.up * configOverride.MaxDepth;
			var directionScaled = direction * configOverride.StepDistance;
			var origin = GetStepOrigin();
            
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
                
				return IsNotTooSteep(hit);
			}
            
			debugger.DrawRay(debugTag, targetPosition, downScaled, Color.red);
			return false;
		}

		private bool IsNotTooSteep(RaycastHit hit)
			=> Vector3.Angle(transform.up, hit.normal) < maxStepFloorNormalAngle;

		/// <inheritdoc/>
		public void Do(Vector3 point, IStepDown.Config configOverride, Action callback = null)
			=> StartCoroutine(DoCoroutine(point, configOverride, callback));

		/// <inheritdoc/>
		public IEnumerator DoCoroutine(Vector3 destination, IStepDown.Config configOverride = null, Action callback = null)
		{
			configOverride ??= config;
			yield return StepUtils.Do(transform, destination, configOverride.Duration, configOverride.StepCurve, callback);
		}
        
		private Vector3 GetStepOrigin()
			=> transform.position + transform.up * (-distanceToFeet);

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
			var origin = GetStepOrigin();
			var downScaled = -transform.up * config.MaxDepth;
			var forwardScaled = _lastDirection * config.StepDistance;
			Gizmos.color = Color.green;
			Gizmos.DrawRay(origin, forwardScaled);
			Gizmos.color = Color.red;
			Vector3 targetPosition = origin + forwardScaled;
			Gizmos.DrawRay(targetPosition, downScaled);
			Gizmos.color = Color.blue;
			Gizmos.DrawRay(transform.position, -transform.up * distanceToFeet);
			Gizmos.color = Color.gray;
			Gizmos.DrawRay(GetFeetPosition(), forwardScaled);
		}
	}
}