using System;
using Core;
using Core.Movement;
using Player;
using UnityEngine;
using UnityEngine.Events;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Rideables
{
	public abstract class Rhea : AdvancedMonoBehaviour, IRideable
	{
		[SerializeField]
		protected float speed;
		[SerializeField]
		protected float speedWhenMounted;

		[SerializeField]
		private Transform mount;

		[SerializeField]
		protected float torque;
		
		[SerializeField]
		protected float torqueWhenMounted;

		[SerializeField]
		private float breakCooldown;

		[Header("Events")]
		[SerializeField]
		protected UnityEvent onBreak;

		[SerializeField]
		protected UnityEvent onBroke;

		protected IMovement Movement;
		private CountDownTimer _breakCooling;

		private bool _isMounted;

		[SerializeField]
		private float attentionRadius;

		[SerializeField]
		private LayerMask interactables;

		public Transform GetMount() => mount;

		public void Mount()
		{
			_isMounted = true;
		}
		public void DisMount()
		{
			_isMounted = false;
			Break();
		}

		protected abstract void InitializeMovement(out IMovement movement, float speed);

		protected abstract void Break();

		private void OnValidate()
		{
			mount = transform.Find("Mount")
					?? transform.Find("mount")
					?? transform.Find("MOUNT");
		}

		protected override void Awake()
		{
			base.Awake();
			_breakCooling = new CountDownTimer(breakCooldown,
												onBroke.Invoke,
												gameObject.scene.buildIndex);
			InitializeMovement(out Movement, speed);
		}

		protected override void Update()
		{
			base.Update();
			if (_isMounted)
				return;
			Collider[] fruits = new Collider[10];
			if (Physics.OverlapSphereNonAlloc(transform.position,
											attentionRadius,
											fruits,
											interactables) > 0)
			{
				Debug.DrawLine(transform.position, fruits[0].transform.position, Color.cyan);
				Vector3 direction = fruits[0].transform.position - transform.position;
				Movement.Move(transform, direction);
				Movement.Rotate(transform, direction, torque);
			}
		}

		public void Move(Vector3 direction)
		{
			if (_breakCooling.IsTicking || !_isMounted)
				return;

			Movement.Move(transform, direction);
			Movement.Rotate(transform, direction, torqueWhenMounted);
		}

		public void UseAbility()
		{
			if (_breakCooling.IsTicking)
				return;
			_breakCooling.StartTimer();
			Break();
		}
	}
}