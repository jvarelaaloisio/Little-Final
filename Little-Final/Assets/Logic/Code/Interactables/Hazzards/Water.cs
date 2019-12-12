using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Water : Hazzard
{
	#region Private
	protected override void TimerFinishedHandler(string ID)
	{
	}
	#endregion

	#region Collisions
	private void OnCollisionEnter(Collision collision)
	{
		base.OnTriggerEnter(collision.collider);
		if (collision.transform.GetComponent(typeof(IDamageable)))
		{
			Attack();
		}
	}
	#endregion
}
