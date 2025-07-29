using System;
using UnityEngine;

namespace Characters
{
	public interface IFallingController
	{
		/// <summary>
		/// Event risen when <see cref="_rigidbody"/>.<see cref="Rigidbody.velocity"/>.y becomes less than 0
		/// </summary>
		event Action OnStartFalling;

		/// <summary>
		/// Event risen when <see cref="Velocity"/>.y becomes less than 0
		/// </summary>
		event Action OnStopFalling;

		bool IsFalling { get; }
	}
}