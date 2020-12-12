using System;
using UnityEngine;

namespace UpdateManagement
{
	public class CountDownTimer : IUpdateable
	{
		private float currentTime = 0;
		public float totalTime;
		private readonly Action onFinished;
		public bool IsTicking { get; private set; }
		public CountDownTimer(float time, Action onFinished)
		{
			this.totalTime = time;
			this.onFinished = onFinished;
		}

		/// <summary>
		/// Subscribes to updateManager and starts timer
		/// </summary>
		public void StartTimer()
		{
			currentTime = 0;
			IsTicking = true;
			UpdateManager.Instance.UnSubscribe(this);
			UpdateManager.Instance.Subscribe(this);
		}
		/// <summary>
		/// Stops timer and unsubscribes from updateManager
		/// </summary>
		public void StopTimer()
		{
			IsTicking = false;
			UpdateManager.Instance.UnSubscribe(this);
		}
		/// <summary>
		/// Method used for UpdateManager. Don't Call.
		/// </summary>
		public void OnUpdate()
		{
			currentTime += Time.deltaTime;
			if (currentTime >= totalTime)
			{
				UpdateManager.Instance.UnSubscribe(this);
				onFinished?.Invoke();
			}
		}
	}
}
