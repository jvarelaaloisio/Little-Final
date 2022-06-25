using System.Collections;
using Core.Debugging;
using UnityEngine;
using UnityEngine.Events;

namespace Core.Stamina
{
	public class StaminaRefill : MonoBehaviour
	{
		[SerializeField]
		private Debugger debugger;

		[SerializeField]
		private bool refillCompletely;

		[SerializeField]
		private int refillAmount;

		[SerializeField]
		private UnityEvent onConsumed;

		[SerializeField]
		private float refillDelay = .1f;

		private Coroutine _refillCoroutine;

		private string DebugTag => name + " (Stamina Refill)";

		public void StartRefillTimer(Transform target)
		{
			var myComp = target
				.GetComponents<MonoBehaviour>();
			foreach (var behaviour in myComp)
			{
				var asdf = behaviour as IStaminaContainer;
				if (( asdf) != null)
				{
					
				}
			}
			IStaminaContainer container = target.GetComponent<IStaminaContainer>();
			if (!target.TryGetComponent(out IStaminaContainer staminaContainer))
			{
				debugger.LogError(DebugTag, $"{target.name} has no component that implements IStaminaContainer");
				return;
			}

			_refillCoroutine = StartCoroutine(RefillInternal(staminaContainer.Stamina));
			debugger.Log(DebugTag, $"Started stamina refill timer\nTarget: {target.name}", this);
		}

		public void CancelRefillTimer()
		{
			if (_refillCoroutine != null)
				StopCoroutine(_refillCoroutine);
			debugger.Log(DebugTag, $"stopped stamina refill timer", this);
		}

		private IEnumerator RefillInternal(Player.Stamina.Stamina stamina)
		{
			yield return new WaitForSeconds(refillDelay);
			if (refillCompletely)
			{
				stamina.RefillCompletely();
				debugger.Log(DebugTag, $"Refilled target's stamina completely", this);
			}
			else
			{
				stamina.ConsumeStamina(-refillAmount);
				debugger.Log(DebugTag, $"Refilled target's stamina for {refillAmount} points", this);
			}

			onConsumed.Invoke();
		}
	}
}