using UnityEngine;

namespace Interactions.Pickable
{
	public class HandContainer : MonoBehaviour
	{
		[SerializeField]
		private Transform hand;


		public Transform Hand => hand;
	}
}