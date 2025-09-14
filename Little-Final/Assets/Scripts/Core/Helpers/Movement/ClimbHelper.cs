using UnityEngine;

namespace Core.Helpers.Movement
{
	public static class ClimbHelper
	{
		private static readonly LayerMask InteractableLayerMask = LayerMask.GetMask("Interactable", "Fruit");
		
		public static bool CanClimb(Vector3 position,
		                            Vector3 direction,
		                            float maxDistance,
		                            float maxDegrees,
		                            out RaycastHit hit)
		{
			if (Physics.Raycast(position,
				direction,
				out hit,
				maxDistance,
				//TODO:Esto esta hardcodeado la concha de tu hermana
				~LayerMask.GetMask("NonClimbable", "Interactable", "Fruit", "RheaFeet")))
			{
				Debug.DrawLine(position, hit.point, Color.white);
				return hit.normal.y * Mathf.Rad2Deg <= Mathf.Abs(maxDegrees);
			}

			Debug.DrawRay(position, direction * maxDistance, Color.black);
			return false;
		}

		public static bool CanMove(Vector3 position,
		                           Vector3 forwardDirection,
		                           Vector3 displacementDirection,
		                           float desiredDisplacement,
		                           float maxDistanceFromWall,
		                           float maxDegrees,
		                           out RaycastHit hit)
		{
			//Check Direction drawn in red
			Debug.DrawRay(position, displacementDirection * desiredDisplacement, Color.red);
			if (Physics.Raycast(position,
				displacementDirection,
				out hit,
				desiredDisplacement,
				~InteractableLayerMask))
			{
				return false;
			}

			//Check if there is still wall drawn in green
			Debug.DrawRay(position + displacementDirection * desiredDisplacement,
				forwardDirection * maxDistanceFromWall, Color.green);
			return CanClimb(position + displacementDirection * desiredDisplacement,
				forwardDirection,
				maxDistanceFromWall,
				maxDegrees,
				out hit);
		}

		//TODO: Move to another class. This is now being used by more than the climb related classes
		//Update on this, we now have the StepUp component
		public static bool CanStepUp(Vector3 actualPosition,
		                              Vector3 up,
		                              Vector3 forward,
		                              float maxUpDistance,
		                              float maxForwardDistance,
		                              out RaycastHit hit)
		{
			hit = new RaycastHit();
			Debug.DrawRay(actualPosition, up * maxUpDistance, Color.red, 1f);
			if (Physics.Raycast(actualPosition, up, maxUpDistance, ~InteractableLayerMask))
				return false;
			Vector3 targetPosition = actualPosition + up * maxUpDistance + forward * maxForwardDistance;
			Debug.DrawRay(targetPosition, -up, Color.green, 1f);
			return Physics.Raycast(targetPosition, -up, out hit, maxUpDistance, ~InteractableLayerMask);
		}
	}
}