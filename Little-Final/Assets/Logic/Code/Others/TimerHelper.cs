using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class TimerHelper
{
	public static Timer_DEPRECATED SetupTimer(float time, string id, GameObject parent, ClockTicking timerFinishedHandler)
	{
		Timer_DEPRECATED newTimer = parent.AddComponent<Timer_DEPRECATED>();
		newTimer.Instantiate(time, id);
		newTimer.ClockTickingEvent += timerFinishedHandler;
		return newTimer;
	}
}
