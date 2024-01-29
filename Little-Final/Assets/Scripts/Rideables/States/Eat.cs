using System;
using System.Collections;
using Core.Debugging;
using HealthSystem.Runtime;
using UnityEngine;

namespace Rideables.States
{
	public class Eat<T> : CharacterState<T>
	{
		public event Action OnFinishedFruit = delegate { };
		private readonly Awareness _awareness;
		private readonly float _bytePeriod;
		private readonly float _firstDelay;
		private readonly int _byteDamage;
		private readonly MonoBehaviour _mono;
		private Coroutine _eatingCoroutine;
		private Transform _fruit;
		private IHealthComponent _fruitHealth;

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
			_fruit = _awareness.Fruit;
			base.Awake();
			if (_fruit && _fruit.TryGetComponent(out _fruitHealth))
			{
				_fruitHealth.Health.OnDeath += OnFruitDeath;
			}
			if (_eatingCoroutine != null)
			{
				_mono.StopCoroutine(_eatingCoroutine);
			}
			_eatingCoroutine = _mono.StartCoroutine(ByteFruit());
		}

		private void OnFruitDeath()
		{
			if (_eatingCoroutine != null)
			{
				_mono.StopCoroutine(_eatingCoroutine);
			}
			OnFinishedFruit();
		}

		public override void Sleep()
		{
			if (_fruitHealth is { Health: not null })
				_fruitHealth.Health.OnDeath -= OnFruitDeath;
			_mono.StopCoroutine(_eatingCoroutine);
			_eatingCoroutine = null;
			base.Sleep();
		}

		private IEnumerator ByteFruit()
		{
			WaitForSeconds waitForPeriod = new WaitForSeconds(_bytePeriod);
			yield return new WaitForSeconds(_firstDelay);
			while (true)
			{
				if (!_fruit)
				{
					CompletedObjective();
					yield break;
				}

				if (_fruit.TryGetComponent(out IHealthComponent damageable))
					damageable.TakeDamage(_byteDamage);

				yield return waitForPeriod;
			}
		}
	}
}