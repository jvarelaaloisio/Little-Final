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
		/// Goal Speed for the movement
		/// </summary>
		public readonly float GoalSpeed;

		public static MovementRequest InvalidRequest => new MovementRequest(Vector3.zero, 0);

		public MovementRequest(Vector3 direction, float goalSpeed)
		{
			Direction = direction;
			GoalSpeed = goalSpeed;
		}

		public Vector3 GetGoalVelocity() => Direction * GoalSpeed;

		public bool IsValid() => this != InvalidRequest;

		public bool Equals(MovementRequest other)
		{
			return Direction.Equals(other.Direction) && GoalSpeed.Equals(other.GoalSpeed);
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
				hashCode = (hashCode * 397) ^ GoalSpeed.GetHashCode();
				return hashCode;
			}
		}

		public override string ToString()
		{
			return IsValid()
						? $"MovementRequest({Direction}, {GoalSpeed})"
						: $"MovementRequest(Invalid)";
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