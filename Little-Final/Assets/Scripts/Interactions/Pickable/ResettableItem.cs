using System.Collections;
using Core.Interactions;
using Events.Channels;
using HealthSystem.Runtime;
using UnityEngine;

namespace Interactions.Pickable
{
	public class ResettableItem : PickableItem
	{
		[SerializeField]
		private float resetAfterSeconds = 120;
		
		[Header("Event Channels Listened")]
		[Tooltip("Can be null")]
		[SerializeField]
		private VoidChannelSo forceReset;
		
		private IHealthComponent _health;

		private Coroutine _deathTimer;
		
		private string DebugTag => name + " (Reset)";

		private void Awake()
		{
			_health = GetComponent<IHealthComponent>();
			if (_health == null)
			{
				debugger.LogError(DebugTag, $"{nameof(_health)} component not found", this);
			}
			forceReset.SubscribeSafely(ResetItem);
		}

		public override void Interact(IInteractor interactor)
		{
			base.Interact(interactor);
			if (_deathTimer != null)
				StopCoroutine(_deathTimer);
			_deathTimer = StartCoroutine(ResetIn(resetAfterSeconds));
		}

		protected override void PutDownInternal()
		{
			base.PutDownInternal();
			if (_deathTimer != null)
				StopCoroutine(_deathTimer);
		}
		
		private IEnumerator ResetIn(float seconds)
		{
			yield return new WaitForSeconds(seconds);
			ResetItem();
		}

		private void ResetItem()
		{
			if (_health == null)
			{
				debugger.LogError(DebugTag, $"Damageable component not found", this);
				return;
			}

			_health.Health.Kill();
		}

		private void OnDestroy()
		{
			forceReset.UnsubscribeSafely(ResetItem);
		}
	}
}
