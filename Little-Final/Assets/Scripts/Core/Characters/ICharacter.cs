using Core.Acting;
using UnityEngine;

namespace Characters
{
	public interface ICharacter
	{
		MovementData Movement { get; set; }
		Vector3 Velocity { get; set; }
		Transform transform { get; }
		GameObject gameObject { get; }

		/// <summary>
		/// Adds an upwards force
		/// <remarks>Validations for simple, double and multiple jumps must be done by the controlling class.</remarks>
		/// </summary>
		/// <param name="force">Value to multiply with <see cref="Transform"/>.<see cref="Transform.up"/></param>
		void Jump(float force);
	}

	public interface ICharacter<TData> : ICharacter
	{
		IActor<TData> Actor { get; }
	}
}