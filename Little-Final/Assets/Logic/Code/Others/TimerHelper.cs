using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class TimerHelper
{
	public static Timer SetupTimer(float time, string id, GameObject parent, ClockTicking timerFinishedHandler)
	{
		Timer newTimer = parent.AddComponent<Timer>();
		newTimer.Instantiate(time, id);
		newTimer.ClockTickingEvent += timerFinishedHandler;
		return newTimer;
	}
}
