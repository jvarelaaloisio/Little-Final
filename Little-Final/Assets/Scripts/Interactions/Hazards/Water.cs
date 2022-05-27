using System;
using UnityEngine;

namespace Interactions.Hazards
{
	[Obsolete]
	public class Water : Hazard
	{
		#region Private
		#endregion

		#region Collisions
		protected override void OnTriggerEnter(Collider other)
		{
			base.OnTriggerEnter(other);
			if (other.GetComponent(typeof(IDamageHandler)))
			{
				Attack();
			}
		}

		#endregion
	}
}