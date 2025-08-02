using Core.Acting;
using Core.Stamina;
using Player.Stamina;
using UnityEngine;

namespace Characters
{
	public interface ICharacter
	{
		IActor Actor { get; }
		MovementData Movement { get; set; }
		Vector3 Velocity { get; set; }
		Transform transform { get; }
		GameObject gameObject { get; }
		IFloorTracker FloorTracker { get; set; }
		IFallingController FallingController { get; }
		IStamina Stamina { get; }

		/// <summary>
		/// Adds an upwards force
		/// <remarks>Validations for simple, double and multiple jumps must be done by the controlling class.</remarks>
		/// </summary>
		/// <param name="force">Value to multiply with <see cref="Transform"/>.<see cref="Transform.up"/></param>
		void Jump(float force);
	}

	public interface ICharacter<TData> : ICharacter
	{
		new IActor<TData> Actor { get; }
	}
}