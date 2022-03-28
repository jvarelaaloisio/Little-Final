using System;
using UnityEngine;

namespace Player
{
	public readonly struct MovementRequest : IEquatable<MovementRequest>
	{
		/// <summary>
		/// Direction of the movement
		/// </summary>
		public readonly Vector3 Direction;
		/// <summary>
		/// Value between 0 and 1.
		/// </summary>
		public readonly float AccelerationFactor;
		/// <summary>
		/// Goal Speed for the movement
		/// </summary>
		public readonly float GoalSpeed;

		public static MovementRequest InvalidRequest => new MovementRequest(Vector3.zero, 0, 0);

		public MovementRequest(Vector3 direction, float accelerationFactor, float goalSpeed)
		{
			Direction = direction;
			AccelerationFactor = accelerationFactor;
			GoalSpeed = goalSpeed;
		}

		public Vector3 GetGoalVelocity() => Direction * GoalSpeed;

		public bool IsValid() => this != InvalidRequest;

		public bool Equals(MovementRequest other)
		{
			return Direction.Equals(other.Direction) && AccelerationFactor.Equals(other.AccelerationFactor) && GoalSpeed.Equals(other.GoalSpeed);
		}

		public override bool Equals(object obj)
		{
			return obj is MovementRequest other && Equals(other);
		}

		public override int GetHashCode()
		{
			unchecked
			{
				var hashCode = Direction.GetHashCode();
				hashCode = (hashCode * 397) ^ AccelerationFactor.GetHashCode();
				hashCode = (hashCode * 397) ^ GoalSpeed.GetHashCode();
				return hashCode;
			}
		}

		public static bool operator ==(MovementRequest one, MovementRequest two)
		{
			return one.Equals(two);
		}

		public static bool operator !=(MovementRequest one, MovementRequest two)
		{
			return !(one == two);
		}
	}
}