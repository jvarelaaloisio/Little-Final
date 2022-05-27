using System;
using Core.Extensions;
using Core.Movement;
using UnityEngine;

namespace Rideables.States
{
	public class Walk<T> : CharacterState<T>
	{
		private readonly IMovement _movement;
		private readonly float _arrivalDistance;
		private float _originalSpeed;
		private readonly Func<Vector3> _getObjectivePosition;

		public Walk(string name,
					Transform transform,
					Action onCompletedObjective,
					IMovement movement,
					Func<Vector3> getObjectivePosition,
					float arrivalDistance)
			: base(name, transform, onCompletedObjective)
		{
			_movement = movement;
			_getObjectivePosition = getObjectivePosition;
			_arrivalDistance = arrivalDistance;
		}

		public override void Awake()
		{
			base.Awake();
			_originalSpeed = _movement.Speed;
		}

		public override void Update(float deltaTime)
		{
			base.Update(deltaTime);
			Vector3 objPos = _getObjectivePosition();
			Vector3 myPos = MyTransform.position;
			Debug.DrawLine(myPos, objPos, Color.white);
			float distanceFromObj = Vector3.Distance(myPos, objPos);
			if (distanceFromObj <= _arrivalDistance)
			{
				CompletedObjective();
				return;
			}

			Vector3 direction = (objPos - myPos).IgnoreY();
			_movement.Speed = Mathf.Lerp(0.01f, _originalSpeed, Mathf.Clamp01(distanceFromObj - _arrivalDistance));
			_movement.Move(MyTransform, direction);
			_movement.Rotate(MyTransform, direction);
		}

		public override void Sleep()
		{
			base.Sleep();
			_movement.Speed = _originalSpeed;
		}
	}
}