using System;
using UnityEngine;

namespace Core.Movement
{
	public class Climber : MonoBehaviour, IClimber
	{
		/// <inheritdoc />
		[field: SerializeField] public IClimber.Config DefaultConfig { get; private set; }

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
				Debug.DrawLine(position, hit.point, Color.white);
				return IClimber.CanClimb(hit, cfg.MaxDegrees);
			}

			Debug.DrawRay(position, direction * cfg.MaxDistance, Color.black);
			return false;
		}

		/// <inheritdoc />
		public bool CanMove(Vector3 direction, out RaycastHit hit, IClimber.Config configOverride = null)
		{
			//Check Direction, drawn in red
			Debug.DrawRay(transform.position, direction, Color.red);
			if (Physics.Raycast(transform.position,
			                    direction,
			                    out hit,
			                    direction.magnitude,
			                    DefaultConfig.Mask))
				return false;

			//Check if there is still a wall, drawn in green
			Debug.DrawRay(transform.position + direction,
			              transform.forward * DefaultConfig.MaxDistance, Color.green);
			return CanClimb(transform.position + direction,
			                transform.forward,
			                out hit,
			                configOverride);
		}
	}
}