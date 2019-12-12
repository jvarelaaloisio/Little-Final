using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class GenericFunctions : MonoBehaviour
{
	#region Private
	protected Timer SetupTimer(float time, string id)
	{
		Timer newTimer = gameObject.AddComponent<Timer>();
		newTimer.Instantiate(time, id);
		newTimer.ClockTickingEvent += TimerFinishedHandler;
		return newTimer;
	}

	protected abstract void TimerFinishedHandler(string ID);

	protected float SmoothFormula(float x, float length)
	{
		float result = (Mathf.Cos(x * Mathf.PI / length + Mathf.PI) + 1) / 2;
		return result;
	}
	#endregion
}
