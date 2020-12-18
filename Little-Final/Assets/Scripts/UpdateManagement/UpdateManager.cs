using UnityEngine;
using System;
using System.Collections.Generic;

namespace UpdateManagement
{
	public class UpdateManager : MonoBehaviour
	{
		private float lastTimeScale;
		private bool isPause;
		private Action update;
		private Action fixedUpdate;
		private Action lateUpdate;
		private static UpdateManager instance;
		private static bool isQuittingAplication = false;
		private static UpdateManager Instance
		{
			get
			{
				if (instance == null && FindObjectOfType<UpdateManager>() == null)
				{
					GameObject go = new GameObject("UpdateManager");
					instance = go.AddComponent<UpdateManager>();
				}
				return instance;
			}
		}

		private void Awake()
		{
			if (instance == null) instance = this;
			else if (instance != this) Destroy(this);
		}
		private void OnApplicationQuit()
		{
			isQuittingAplication = true;
		}

		#region Update Messages
		private void Update()
		{
			if (isPause)
				return;
			update?.Invoke();
		}
		private void FixedUpdate()
		{
			if (isPause)
				return;
			fixedUpdate?.Invoke();
		}
		private void LateUpdate()
		{
			if (isPause)
				return;
			lateUpdate?.Invoke();
		}
		#endregion

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

		public static void SetPause(bool value)
		{
			if (Instance.isPause == value)
				return;
			Instance.isPause = value;
			if (value)
			{
				Instance.lastTimeScale = Time.timeScale;
				//Time.timeScale = 0;
			}
			//else
				//Time.timeScale = Instance.lastTimeScale;
		}
		
		#region Subscriptions
		/// <summary>
		/// Subscribes to Update
		/// </summary>
		/// <param name="updateable"></param>
		public static void Subscribe(IUpdateable updateable)
		{
			if (isQuittingAplication)
				return;
			Instance.update += updateable.OnUpdate;
		}
		//private void Subscribe(IUpdateable updateable)
		//{
		//	update += updateable.OnUpdate;
		//}
		/// <summary>
		/// Unsubscribes from Update
		/// </summary>
		/// <param name="updateable"></param>
		public static void UnSubscribe(IUpdateable updateable)
		{
			if (isQuittingAplication)
				return;
			Instance.update -= updateable.OnUpdate;
		}
		//private void UnSubscribe(IUpdateable updateable)
		//{
		//	update -= updateable.OnUpdate;
		//}
		/// <summary>
		/// subscribes to FixedUpdate
		/// </summary>
		/// <param name="fixedUpdateable"></param>
		public static void Subscribe(IFixedUpdateable fixedUpdateable)
		{
			if (isQuittingAplication)
				return;
			Instance.update += fixedUpdateable.OnFixedUpdate;
		}
		//public void SubscribeFixed_(IFixedUpdateable fixedUpdateable)
		//{
		//	update += fixedUpdateable.OnFixedUpdate;
		//}
		/// <summary>
		/// Unsubscribes from FixedUpdate
		/// </summary>
		/// <param name="fixedUpdateable"></param>
		public static void UnSubscribe(IFixedUpdateable fixedUpdateable)
		{
			if (isQuittingAplication)
				return;
			Instance.update -= fixedUpdateable.OnFixedUpdate;
		}
		//public void UnSubscribeFixed_(IFixedUpdateable fixedUpdateable)
		//{
		//	update -= fixedUpdateable.OnFixedUpdate;
		//}
		/// <summary>
		/// subscribes to LateUpdate
		/// </summary>
		/// <param name="lateUpdateable"></param>
		public static void Subscribe(ILateUpdateable lateUpdateable)
		{
			if (isQuittingAplication)
				return;
			Instance.lateUpdate += lateUpdateable.OnLateUpdate;
		}
		//public void SubscribeLate_(ILateUpdateable lateUpdateable)
		//{
		//	lateUpdate += lateUpdateable.OnLateUpdate;
		//}
		/// <summary>
		/// Unsubscribes from LateUpdate
		/// </summary>
		/// <param name="lateUpdateable"></param>
		public static void UnSubscribe(ILateUpdateable lateUpdateable)
		{
			if (isQuittingAplication)
				return;
			Instance.lateUpdate -= lateUpdateable.OnLateUpdate;
		}
		//public void UnSubscribeLate_(ILateUpdateable lateUpdateable)
		//{
		//	lateUpdate -= lateUpdateable.OnLateUpdate;
		//}
		#endregion
	}
}