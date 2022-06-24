using System;
using System.Collections;
using Core.Debugging;
using Core.LifeSystem;
using UnityEngine;

namespace Rideables.States
{
	public class Eat<T> : CharacterState<T>
	{
		private readonly Awareness _awareness;
		private readonly float _bytePeriod;
		private readonly float _firstDelay;
		private readonly int _byteDamage;
		private readonly MonoBehaviour _mono;
		private Coroutine eatingCoroutine;

		public Eat(string name,
					Transform transform,
					Action onCompletedObjective,
					Debugger debugger,
					Awareness awareness,
					float bytePeriod,
					float firstDelay,
					int byteDamage, MonoBehaviour mono)
			: base(name, transform, onCompletedObjective, debugger)
		{
			_awareness = awareness;
			_bytePeriod = bytePeriod;
			_firstDelay = firstDelay;
			_byteDamage = byteDamage;
			_mono = mono;
		}

		public override void Awake()
		{
			base.Awake();
			if (eatingCoroutine != null)
			{
				_mono.StopCoroutine(eatingCoroutine);
			}
			eatingCoroutine = _mono.StartCoroutine(ByteFruit());
		}

		public override void Sleep()
		{
			_mono.StopCoroutine(eatingCoroutine);
			eatingCoroutine = null;
			base.Sleep();
		}

		private IEnumerator ByteFruit()
		{
			WaitForSeconds waitForPeriod = new WaitForSeconds(_bytePeriod);
			yield return new WaitForSeconds(_firstDelay);
			while (true)
			{
				if (!_awareness.Fruit)
				{
					CompletedObjective();
					yield break;
				}

				if (_awareness.Fruit.TryGetComponent(out IDamageable damageable))
					damageable.TakeDamage(_byteDamage);

				yield return waitForPeriod;
			}
		}
	}
}