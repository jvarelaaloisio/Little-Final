using System;
using UnityEngine;

namespace Characters
{
    [Serializable]
    public class MovementData : IEquatable<MovementData>
    {
        /// <summary>
        /// Direction of the movement
        /// </summary>
        public Vector3 direction;

        /// <summary>
        /// The acceleration for this movement
        /// </summary>
        public float acceleration;
		
        /// <summary>
        /// Goal Speed for the movement
        /// </summary>
        public float goalSpeed;

        public static MovementData InvalidRequest => new(Vector3.zero, float.NaN, float.NaN);

        public Vector3 GoalVelocity => direction * goalSpeed;

        public MovementData(Vector3 direction,
            float goalSpeed,
            float acceleration)
        {
            this.direction = direction;
            this.goalSpeed = goalSpeed;
            this.acceleration = acceleration;
        }

        public bool IsValid() => this != InvalidRequest;

        public bool Equals(MovementData other) => other is not null && direction.Equals(other.direction) && goalSpeed.Equals(other.goalSpeed);

        public override bool Equals(object obj) => obj is MovementData other && Equals(other);

        public override int GetHashCode()
        {
            unchecked
            {
                var hashCode = direction.GetHashCode();
                hashCode = (hashCode * 397) ^ goalSpeed.GetHashCode();
                return hashCode;
            }
        }

        public override string ToString() =>
            IsValid()
                ? $"MovementRequest({direction}, {goalSpeed}, {acceleration})"
                : $"MovementRequest(Invalid)";

        public static bool operator ==(MovementData one, MovementData two) => one.Equals(two);

        public static bool operator !=(MovementData one, MovementData two) => !(one == two);
    }
}