using System;
using UnityEngine;

namespace Player
{
	/// <summary>
	/// Request for a force in the rigidBody
	/// </summary>
	public readonly struct ForceRequest: IEquatable<ForceRequest>
	{
		/// <summary>
		/// Scaled direction for the force
		/// (is world direction)
		/// </summary>
		public readonly Vector3 Force;
		/// <summary>
		/// ForceMode
		/// </summary>
		public readonly ForceMode Mode;

		public ForceRequest(Vector3 force, ForceMode mode = ForceMode.Impulse)
		{
			this.Force = force;
			Mode = mode;
		}

		public bool Equals(ForceRequest other)
		{
			return Force.Equals(other.Force) && Mode == other.Mode;
		}

		public override bool Equals(object obj)
		{
			return obj is ForceRequest other && Equals(other);
		}

		public override int GetHashCode()
		{
			unchecked
			{
				return (Force.GetHashCode() * 397) ^ (int) Mode;
			}
		}

		public override string ToString()
			=> $"ForceRequest(Force: {Force}, Mode: {Mode})";
	}
}