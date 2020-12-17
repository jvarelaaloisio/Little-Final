using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CharacterMovement
{
	public static class ClimbHelper
	{
		private readonly static LayerMask Interactable;
		static ClimbHelper()
		{
			Interactable = LayerMask.GetMask("Interactable");
		}
		public static bool CanClimb(Vector3 position,
									Vector3 direction,
									float maxDistance,
									float maxDegrees,
									out RaycastHit hit)
		{
			if(Physics.Raycast(position,
									direction,
									out hit,
									maxDistance,
									~LayerMask.GetMask("NonClimbable", "Interactable")))
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
								~Interactable))
			{
				return false;
			}
			//Check if there is still wall drawn in green
			Debug.DrawRay(position + displacementDirection * desiredDisplacement, forwardDirection * maxDistanceFromWall, Color.green);
			return CanClimb(position + displacementDirection * desiredDisplacement,
						forwardDirection,
						maxDistanceFromWall,
						maxDegrees,
						out hit);
		}

		public static bool CanClimbUp(Vector3 actualPosition,
										Vector3 up,
										Vector3 forward,
										float maxUpDistance,
										float maxForwardDistance,
										out RaycastHit hit)
		{
			hit = new RaycastHit();
			if (Physics.Raycast(actualPosition, up, maxUpDistance, ~Interactable))
				return false;
			Vector3 targetPosition = actualPosition + up * maxUpDistance + forward * maxForwardDistance;
			return Physics.Raycast(targetPosition, -up, out hit, maxUpDistance, ~Interactable);
		}

	}
}
