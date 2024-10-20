﻿using System;
using Core.LifeSystem;
using Events.UnityEvents;
using LS;
using UnityEngine;
using Debugger = Core.Debugging.Debugger;

namespace LifeSystem
{
	[AddComponentMenu("Interactions/Damageable")]
	[Obsolete]
	public class DamageableWrapper : MonoBehaviour, IDamageable
	{
		[SerializeField]
		private int maxLifePoints;

		[SerializeField]
		private bool allowOverFlow;

		[Header("Events")]
		[SerializeField]
		private IntUnityEvent onLifeChanged;

		[SerializeField]
		private SmartEvent onDeath;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;

		private Damageable _damageable;

		public int MaxLifePoints => _damageable.MaxLifePoints;

		public bool AllowOverFlow => _damageable.AllowOverflow;

		public int LifePoints => _damageable.LifePoints;
		public Action OnDeath => onDeath;

		[ContextMenu("Run Awake (if serialized values have changed)")]
		private void Awake()
		{
			_damageable = new Damageable(maxLifePoints, maxLifePoints, allowOverFlow)
						{
							OnDeath = onDeath.Invoke
						};
		}

		public void TakeDamage(int damagePoints)
		{
			_damageable.TakeDamage(damagePoints);
			onLifeChanged.Invoke(LifePoints);
			debugger.Log(name, $"Took {damagePoints} points of damage." +
								$"\nCurrent HP: {LifePoints}/{MaxLifePoints}", this);
		}

		event Action IDamageable.OnDeath
		{
			add => onDeath += value;
			remove => onDeath -= value;
		}
	}
}