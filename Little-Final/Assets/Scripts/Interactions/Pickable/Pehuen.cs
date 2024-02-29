using System;
using System.Collections;
using Core.Interactions;
using HealthSystem.Runtime.Components;
using UnityEngine;

namespace Interactions.Pickable
{
	public class Pehuen : ResettableItem
	{
		[SerializeField] private HealthComponent healthComponent;
		[SerializeField] private TemporalBuff temporalBuff;
		[SerializeField] private int selfDamagePerBuff = 1;
		[SerializeField] private float buffDelay = .25f;
		
		private BuffTarget _lastBuffTarget;
		private Coroutine _resetCoroutine;
		private Coroutine _applicationCoroutine;

		protected override void OnValidate()
		{
			base.OnValidate();
			healthComponent ??= GetComponent<HealthComponent>();
			temporalBuff ??= GetComponent<TemporalBuff>();
		}

		private IEnumerator Start()
		{
			yield return new WaitUntil(() => healthComponent != null);
			healthComponent.Health.OnDeath += HandleDeath;
		}

		private void OnDisable()
		{
			if (healthComponent)
				healthComponent.Health.OnDeath -= HandleDeath;
		}

		public override void Interact(IInteractor interactor)
		{
			base.Interact(interactor);
			if (temporalBuff.TryGetBuffable(interactor.transform, out var buffable))
				_applicationCoroutine = StartCoroutine(ApplyWhileLoosingLife(buffable));
		}

		protected override void PutDownInternal()
		{
			base.PutDownInternal();
			if (_applicationCoroutine != null)
			{
				StopCoroutine(_applicationCoroutine);
			}
		}

		private IEnumerator ApplyWhileLoosingLife(IBuffable buffable)
		{
			var originalValue = buffable.BuffMultiplier;
			while (healthComponent.Health.HP > 0)
			{
				yield return new WaitForSeconds(buffDelay);
				temporalBuff.ApplyBuff(buffable);
				healthComponent.TakeDamage(selfDamagePerBuff);

				yield return new WaitUntil(BuffEnded);
				
				bool BuffEnded() => Math.Abs(buffable.BuffMultiplier - originalValue) < .001f;
			}
		}

		private void HandleDeath()
		{
			ForceLoseInteraction();
		}
	}
}