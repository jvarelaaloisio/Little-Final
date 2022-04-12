using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Obsolete]
public class Water : Hazzard
{
	#region Private
	#endregion

	#region Collisions
	protected override void OnTriggerEnter(Collider other)
	{
		base.OnTriggerEnter(other);
		if (other.GetComponent(typeof(IDamageable)))
		{
			Attack();
		}
	}

	#endregion
}