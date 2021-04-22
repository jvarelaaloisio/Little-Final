using System;
using System.Collections.Generic;

public class CollectableHelper
{
	private readonly Dictionary<int, Action> events;
	public int CollectableAmount { get; private set; }
	private static CollectableHelper instance;

	public static CollectableHelper Instance
	{
		get
		{
			if (instance == null)
				instance = new CollectableHelper();
			return instance;
		}
	}

	private CollectableHelper()
	{
		events = new Dictionary<int, Action>();
	}

	public void AddCollectable()
	{
		CollectableAmount++;
		if (events.ContainsKey(CollectableAmount))
			events[CollectableAmount].Invoke();
	}

	public void AddEvent(int collectableAmount, Action action)
	{
		if (events.ContainsKey(collectableAmount))
			events[collectableAmount] += action;
		else
			events.Add(collectableAmount, action);
	}
}
