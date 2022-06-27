using System.Collections;
using Core.Extensions;
using Core.Interactions;
using Core.Movement;
using UnityEngine;
using UnityEngine.AI;

namespace Rideables
{
	[RequireComponent(typeof(Rigidbody))]
	public class RheaImpl : Rhea
	{
		[SerializeField]
		private Rigidbody rigidBody;

		[SerializeField]
		private NavMeshAgent agent;

		[SerializeField]
		private float breakForce;

		private readonly WaitForFixedUpdate _waitForFixedUpdate = new WaitForFixedUpdate();
		private Vector3 _origin;


		protected override void OnValidate()
		{
			base.OnValidate();
			if (!rigidBody) gameObject.TryGetComponent(out rigidBody);
			if (!agent) gameObject.TryGetComponent(out agent);
		}

		protected override void Awake()
		{
			base.Awake();
			_origin = transform.position;
		}

		protected override void OnPlayerDies()
		{
			OnStateCompletedObjective();
			agent.Warp(_origin);
		}

		protected override void InitializeMovement(out IMovement movement, float speed)
			=> movement = new MovementThroughForce(this, rigidBody, speed, torque);

		protected override void InitializeNavigator(out INavigator navigator)
			=> navigator = new NavMeshNavigator(agent, agent.stoppingDistance);

		protected override void Brake()
		{
			StopCoroutine(AddBreakForce());
			StartCoroutine(AddBreakForce());

			IEnumerator AddBreakForce()
			{
				yield return _waitForFixedUpdate;
				Vector3 force = -rigidBody.velocity.IgnoreY() * breakForce * Time.fixedDeltaTime;
				Debug.DrawRay(transform.position, force, Color.white);
				rigidBody.AddForce(force, ForceMode.Force);
			}
		}

		public override void Interact(IInteractor interactor)
		{
			base.Interact(interactor);
			agent.enabled = false;
		}

		public override void Leave()
		{
			base.Leave();
			agent.enabled = true;
		}

		protected override Vector3 GetCurrentVelocity()
		{
			return IsMounted
						? rigidBody.velocity
						: agent.velocity;
		}

#if UNITY_EDITOR

		[ContextMenu("Set Normal Floor Distance")]
		private void SetNormalFloorDistance()
		{
			if (Physics.Raycast(transform.position,
								Vector3.down,
								out var hit,
								maxFloorDistance,
								floor))
				Vector3.Distance(hit.point, transform.position);
			else
				Debug.Log("Couldn't collide with floor");
		}
#endif
	}
}