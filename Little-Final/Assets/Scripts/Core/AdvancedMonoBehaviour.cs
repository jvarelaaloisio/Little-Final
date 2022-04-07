using System;
using UnityEngine;

namespace Core
{
	public class AdvancedMonoBehaviour : MonoBehaviour
	{
		public event Action<MonoBehaviour> OnAwake = delegate { };
		public event Action<MonoBehaviour> OnStart = delegate { };
		public event Action<MonoBehaviour, float> OnUpdate = delegate { };
		public event Action<MonoBehaviour, float> OnFixedUpdate = delegate { };
		public event Action<MonoBehaviour, float> OnLateUpdate = delegate { };

		protected virtual void Awake() => OnAwake(this);

		protected virtual void Start() => OnStart(this);

		protected virtual void Update() => OnUpdate(this, Time.deltaTime);

		protected virtual void FixedUpdate() => OnFixedUpdate(this, Time.fixedDeltaTime);

		protected virtual void LateUpdate() => OnLateUpdate(this, Time.deltaTime);
	}
}