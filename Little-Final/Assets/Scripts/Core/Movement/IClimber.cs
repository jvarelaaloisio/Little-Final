using System;
using UnityEngine;
using UnityEngine.Serialization;

namespace Core.Movement
{
	public interface IClimber
	{
		/// <summary/> Default configuration
		Config DefaultConfig { get; }

		/// <summary/> Does a raycast check and validates it based on configuration
		/// <param name="direction">direction for the raycast</param>
		/// <param name="hit">the hit output</param>
		/// <param name="configOverride">if given one, it will be used instead of <see cref="DefaultConfig"/></param>
		/// <returns>True if the climb check is valid</returns>
		bool CanClimb(Vector3 direction, out RaycastHit hit, Config configOverride = null);

		/// <summary/> Does a raycast check and validates it based on configuration
		/// <param name="position">The position from where to do the check</param>
		/// <param name="direction">direction for the raycast</param>
		/// <param name="hit">the hit output</param>
		/// <param name="configOverride">if given one, it will be used instead of <see cref="DefaultConfig"/></param>
		/// <returns>True if the climb check is valid</returns>
		bool CanClimb(Vector3 position, Vector3 direction, out RaycastHit hit, Config configOverride = null);

		/// <summary/> Validates a hit based on <see cref="IClimber.Config"/>
		/// <param name="hit">The hit to check for.</param>
		/// <param name="maxDegrees">The maximum degrees valid for this climber</param>
		/// <returns>True if the normal's angle is less or equal to maxDegrees</returns>
		public static bool CanClimb(RaycastHit hit, float maxDegrees)
			=> hit.normal.y * Mathf.Rad2Deg <= Mathf.Abs(maxDegrees);

		/// <summary>
		/// Validates if there is wall to climb in the given direction
		/// and verifies that there aren't any obstacles in between
		/// </summary>
		/// <param name="direction">The direction to check for.</param>
		/// <param name="hit">The hit output of the raycast</param>
		/// <param name="configOverride">if given one, it will be used instead of <see cref="DefaultConfig"/></param>
		/// <returns></returns>
		bool CanMove(Vector3 direction, out RaycastHit hit, Config configOverride = null);

		[Serializable]
		public class Config
		{
			[field: SerializeField, Min(0)] public float MaxDistance { get; private set; } = 0.5f;
			[field: SerializeField, Range(0, 360)] public float MaxDegrees { get; private set; } = 60;
			[field: SerializeField] public LayerMask Mask { get; set; }
		}
	}
}