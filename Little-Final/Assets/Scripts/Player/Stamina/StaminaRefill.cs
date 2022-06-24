using System.Collections;
using Core.Debugging;
using UnityEngine;
using UnityEngine.Events;

namespace Player.Stamina
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

		private string DebugTag => name + " (Stamina Refill)";
		
		public void TryRefillStamina(Transform target)
		{
			if (!target.TryGetComponent(out PlayerController player))
			{
				debugger.LogError(DebugTag, $"{target.name} has no PlayerController component");
				return;
			}

			StartCoroutine(RefillInternal(player));
		}

		private IEnumerator RefillInternal(PlayerController player)
		{
			yield return new WaitForSeconds(refillDelay);
			Stamina stamina = player.Stamina;
			if(refillCompletely)
				stamina.RefillCompletely();
			else
				stamina.ConsumeStamina(-refillAmount);
			player.LoseInteraction();

			onConsumed.Invoke();
		}
	}
}
