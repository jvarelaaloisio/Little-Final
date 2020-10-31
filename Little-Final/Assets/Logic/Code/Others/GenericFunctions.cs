using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class GenericFunctions : MonoBehaviour
{
	#region Private
	protected Timer_DEPRECATED SetupTimer(float time, string id)
	{
		Timer_DEPRECATED newTimer = gameObject.AddComponent<Timer_DEPRECATED>();
		newTimer.Instantiate(time, id);
		newTimer.ClockTickingEvent += TimerFinishedHandler;
		return newTimer;
	}

	protected abstract void TimerFinishedHandler(string ID);
	#endregion
}
