using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player_Vars_SO : ScriptableObject
{
	private static Player_Vars_SO instance;

	public static Player_Vars_SO Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.FindObjectsOfTypeAll<Player_Vars_SO>()[0];
			}
			if (!instance)
			{
				instance = CreateInstance<Player_Vars_SO>();
			}
			return instance;
		}
	}

	 
}
