using System;
using System.Collections;
using Core.Debugging;
using Core.Interactions;
using Core.LifeSystem;
using Events.Channels;
using UnityEngine;

namespace Interactions.Pickable
{
	[RequireComponent(typeof(IDamageable))]
	public class ResettableItem : PickableItem
	{
		[SerializeField]
		private float resetAfterSeconds = 1;
		
		[SerializeField]
		private int resetDamage = 1000;
		
		[Header("Event Channels Listened")]
		[Tooltip("Can be null")]
		[SerializeField]
		private VoidChannelSo forceReset;
		
		private IDamageable _damageable;

		private Coroutine _deathTimer;
		
		private string DebugTag => name + " (Reset)";

		private void Awake()
		{
			_damageable = GetComponent<IDamageable>();
			forceReset.SubscribeSafely(ResetItem);
		}

		public override void Interact(IInteractor interactor)
		{
			base.Interact(interactor);
			if (_deathTimer != null) StopCoroutine(_deathTimer);
			_deathTimer = StartCoroutine(DieInSeconds(resetAfterSeconds));
		}

		protected override void PutDownInternal()
		{
			base.PutDownInternal();
			if (_deathTimer != null)
				StopCoroutine(_deathTimer);
		}
		
		private IEnumerator DieInSeconds(float delay)
		{
			yield return new WaitForSeconds(delay);
			ResetItem();
		}

		private void ResetItem()
		{
			if (_damageable == null)
			{
				debugger.LogError(DebugTag, $"Damageable component not found", this);
				return;
			}

			_damageable.TakeDamage(resetDamage);
		}

		private void OnDestroy()
		{
			forceReset.UnsubscribeSafely(ResetItem);
		}
	}
}
