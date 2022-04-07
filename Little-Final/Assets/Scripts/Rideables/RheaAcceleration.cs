using Core.Extensions;
using Core.Movement;
using UnityEngine;

namespace Rideables
{
	[RequireComponent(typeof(Rigidbody))]
	public class RheaAcceleration : Rhea
	{
		private Rigidbody _rigidbody;

		protected override void Awake()
		{
			_rigidbody = GetComponent<Rigidbody>();
			base.Awake();
		}

		protected override void InitializeMovement(out IMovement movement, float speed)
		{
			movement = new MovementThroughForce(this, _rigidbody, speed);
		}

		protected override void Break()
		{
			//TODO:Que frene solo estando en el piso
			_rigidbody.AddForce(-_rigidbody.velocity.IgnoreY(), ForceMode.VelocityChange);
		}
	}
}