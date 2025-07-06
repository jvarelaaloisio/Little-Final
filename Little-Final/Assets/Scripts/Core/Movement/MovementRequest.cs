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
		/// The acceleration for this movement
		/// </summary>
		public readonly float Acceleration;
		
		/// <summary>
		/// Goal Speed for the movement
		/// </summary>
		public readonly float GoalSpeed;

		public static MovementRequest InvalidRequest => new(Vector3.zero, 0, 0);

		public MovementRequest(Vector3 direction,
		                       float goalSpeed,
		                       float acceleration)
		{
			Direction = direction;
			GoalSpeed = goalSpeed;
			Acceleration = acceleration;
		}

		public Vector3 GetGoalVelocity() => Direction * GoalSpeed;

		public bool IsValid() => this != InvalidRequest;

		public bool Equals(MovementRequest other) => Direction.Equals(other.Direction) && GoalSpeed.Equals(other.GoalSpeed);

		public override bool Equals(object obj) => obj is MovementRequest other && Equals(other);

		public override int GetHashCode()
		{
			unchecked
			{
				var hashCode = Direction.GetHashCode();
				hashCode = (hashCode * 397) ^ GoalSpeed.GetHashCode();
				return hashCode;
			}
		}

		public override string ToString() =>
			IsValid()
				? $"Movement({Direction}, {GoalSpeed}, {Acceleration})"
				: $"Movement(Invalid)";

		public static bool operator ==(MovementRequest one, MovementRequest two) => one.Equals(two);

		public static bool operator !=(MovementRequest one, MovementRequest two) => !(one == two);
	}
}