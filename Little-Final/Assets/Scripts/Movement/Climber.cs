using UnityEngine;

namespace Core.Movement
{
	public class Climber : MonoBehaviour, IClimber
	{
		/// <inheritdoc />
		[field: SerializeField] public IClimber.Config DefaultConfig { get; private set; }

		[Header("Debug")]
		[SerializeField] private bool drawDebugLines;

		private void Reset()
			=> DefaultConfig.Mask = LayerMask.GetMask("Default", "Floor", "Collider");

		/// <inheritdoc />
		public bool CanClimb(Vector3 direction, out RaycastHit hit, IClimber.Config configOverride = null)
			=> CanClimb(transform.position, direction, out hit, configOverride);

		/// <inheritdoc />
		public bool CanClimb(Vector3 position, Vector3 direction, out RaycastHit hit, IClimber.Config configOverride = null)
		{
			var cfg = configOverride ?? DefaultConfig;
			if (Physics.Raycast(position,
			                    direction,
			                    out hit,
			                    cfg.MaxDistance,
			                    cfg.Mask))
			{
				if (drawDebugLines)
					Debug.DrawRay(hit.point, hit.normal / 3, Color.blue);
				return IClimber.CanClimb(hit, cfg.MaxDegrees);
			}

			if (drawDebugLines)
				Debug.DrawRay(position, direction * cfg.MaxDistance, Color.red);
			return false;
		}

		/// <inheritdoc />
		public bool CanMove(Vector3 direction, out RaycastHit hit, IClimber.Config configOverride = null)
		{
			var cfg = configOverride ?? DefaultConfig;
			//Check Direction, drawn in red
			var clampedDirection = direction * cfg.MaxDistanceToCorners;
			if (Physics.Raycast(transform.position,
			                    direction,
			                    out hit,
			                    direction.magnitude * cfg.MaxDistanceToCorners,
			                    cfg.Mask))
			{
				if (drawDebugLines)
					Debug.DrawRay(transform.position, clampedDirection, Color.red);
				return false;
			}

			//Check if there is still a wall, drawn in green
			if (drawDebugLines)
				Debug.DrawRay(transform.position, clampedDirection, Color.green);
			return CanClimb(transform.position + clampedDirection,
			                transform.forward,
			                out hit,
			                cfg);
		}
	}
}