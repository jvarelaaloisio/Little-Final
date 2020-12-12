using System;
using UnityEngine;

namespace UpdateManagement
{
	public class ActionOverTime : IUpdateable
	{
		private float currentTime = 0;
		public float totalTime;
		public bool IsRunning { get; private set; }
		private readonly Action action;
		public ActionOverTime(float time, Action<float> action, bool giveLerp = false)
		{
			this.totalTime = time;
			if (giveLerp)
			{
				this.action = () => action(currentTime / totalTime);
			}
			else
			{
				this.action = () => action(currentTime);
			}
		}
		public ActionOverTime(float time, Action action)
		{
			this.totalTime = time;
			this.action = action;
		}

		/// <summary>
		/// Subscribes to updateManager and starts ticking
		/// </summary>
		public void StartAction()
		{
			IsRunning = true;
			currentTime = 0;
			UpdateManager.Instance.UnSubscribe(this);
			UpdateManager.Instance.Subscribe(this);
		}
		/// <summary>
		/// Stops ticking and unsubscribes from updateManager
		/// </summary>
		public void StopAction()
		{
			IsRunning = false;
			UpdateManager.Instance.UnSubscribe(this);
		}
		/// <summary>
		/// Method used for UpdateManager. Don't Call.
		/// </summary>
		public void OnUpdate()
		{
			currentTime += Time.deltaTime;
			if (currentTime > totalTime) currentTime = totalTime;
			action();
			if (currentTime >= totalTime)
			{
				currentTime = 0;
				UpdateManager.Instance.UnSubscribe(this);
			}
		}
	}
}
