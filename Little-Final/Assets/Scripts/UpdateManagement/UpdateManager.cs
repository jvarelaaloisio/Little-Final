using UnityEngine;
using System;
using System.Collections.Generic;

namespace UpdateManagement
{
	public class UpdateManager : MonoBehaviour
	{
		private Action update;
		private Action fixedUpdate;
		private Action lateUpdate;
		public static UpdateManager Instance { get; private set; }

		private void Awake()
		{
			if (Instance == null) Instance = this;
			else if (Instance != this) Destroy(this);
		}

		private void Update()
		{
			update?.Invoke();
		}
		private void FixedUpdate()
		{
			fixedUpdate?.Invoke();
		}

		private void LateUpdate()
		{
			lateUpdate?.Invoke();
		}

		/// <summary>
		/// Resets the delegates.
		/// Use this when changing scenes
		/// </summary>
		public void ResetUpdateDelegates()
		{
			update = null;
			fixedUpdate = null;
			lateUpdate = null;
		}

		#region Subscriptions
		/// <summary>
		/// Subscribes to Update
		/// </summary>
		/// <param name="updateable"></param>
		public void Subscribe(IUpdateable updateable)
		{
			update += updateable.OnUpdate;
		}
		/// <summary>
		/// Unsubscribes from Update
		/// </summary>
		/// <param name="updateable"></param>
		public void UnSubscribe(IUpdateable updateable)
		{
			update -= updateable.OnUpdate;
		}
		/// <summary>
		/// subscribes to FixedUpdate
		/// </summary>
		/// <param name="fixedUpdateable"></param>
		public void SubscribeFixed(IFixedUpdateable fixedUpdateable)
		{
			update += fixedUpdateable.OnFixedUpdate;
		}
		/// <summary>
		/// Unsubscribes from FixedUpdate
		/// </summary>
		/// <param name="fixedUpdateable"></param>
		public void UnSubscribeFixed(IFixedUpdateable fixedUpdateable)
		{
			update -= fixedUpdateable.OnFixedUpdate;
		}
		/// <summary>
		/// subscribes to LateUpdate
		/// </summary>
		/// <param name="lateUpdateable"></param>
		public void SubscribeLate(ILateUpdateable lateUpdateable)
		{
			lateUpdate += lateUpdateable.OnLateUpdate;
		}
		/// <summary>
		/// Unsubscribes from LateUpdate
		/// </summary>
		/// <param name="lateUpdateable"></param>
		public void UnSubscribeLate(ILateUpdateable lateUpdateable)
		{
			lateUpdate -= lateUpdateable.OnLateUpdate;
		}
		#endregion
	}
}