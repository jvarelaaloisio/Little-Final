using System.Collections;
using Core.Extensions;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
using Random = UnityEngine.Random;

namespace Rideables
{
	public class RheaAnimatorView : MonoBehaviour, ILateUpdateable
	{
		[SerializeField]
		private Rigidbody rigidbody;

		[SerializeField]
		private Animator animator;

		[SerializeField]
		private Rhea rhea;

		[Header("Animator Parameters")]
		[SerializeField]
		private string speedParameter = "run_blend";

		[SerializeField]
		private string runTrigger = "run";

		[SerializeField]
		private string idleTrigger = "idle";

		[SerializeField]
		private string idleRandomFloat = "Idle_random";

		[SerializeField]
		private int idleRandomQty;

		[SerializeField]
		private float idleRandomChangePeriod;

		[SerializeField]
		private float idleResetPeriod;

		private bool wasRunning = false;

		private void OnValidate()
		{
			if (!animator) TryGetComponent(out animator);
			if (!rigidbody) TryGetComponent(out rigidbody);
		}

		private void Awake()
		{
			if (!rigidbody) Debug.LogError("Rigidbody field not set", this);
			if (!animator) Debug.LogError("Animator field not set", this);
		}

		private void Start()
		{
			UpdateManager.Subscribe(this);
			StartCoroutine(SetRandomIdle(idleRandomChangePeriod, idleResetPeriod));
		}

		public void OnLateUpdate()
		{
			float horizontalSpeed = rigidbody.velocity.XZtoXY().magnitude;
			animator.SetFloat(speedParameter, horizontalSpeed / rhea.Speed);
			bool isRunning = horizontalSpeed > .1f;
			if (isRunning && !wasRunning)
			{
				animator.SetTrigger(runTrigger);
			}
			else if (!isRunning && wasRunning)
			{
				animator.SetTrigger(idleTrigger);
			}

			wasRunning = isRunning;
		}

		private IEnumerator SetRandomIdle(float period, float resetPeriod)
		{
			var waitUntilNextPeriod = new WaitForSeconds(period);
			var waitUntilResetPeriod = new WaitForSeconds(resetPeriod);
			while (true)
			{
				int newNumber = Random.Range(0, idleRandomQty);
				animator.SetInteger(idleRandomFloat, newNumber);
				yield return waitUntilResetPeriod;
				animator.SetInteger(idleRandomFloat, 0);
				yield return waitUntilNextPeriod;
			}
		}
	}
}