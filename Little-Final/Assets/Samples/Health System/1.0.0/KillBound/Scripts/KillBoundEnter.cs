using HealthSystem.Runtime.Helpers;
using UnityEngine;

namespace HealthSystem.Runtime.Components.Damage
{
	[Tooltip("Component that kills anything that enters it")]
	public class KillBoundEnter : MonoBehaviour
	{
		protected void OnTriggerEnter(Collider other) => other.TryToKill();

		private void OnTriggerEnter2D(Collider2D other) => other.TryToKill();
		
		private void OnDrawGizmos()
		{
			Gizmos.color = Color.red;
			if (TryGetComponent<BoxCollider>(out var boxCollider))
			{
				var bounds = boxCollider.bounds;
				Gizmos.DrawWireCube(bounds.center, bounds.size);
			}
			if (TryGetComponent<SphereCollider>(out var sphereCollider))
			{
				var center = sphereCollider.bounds.center;
				var scale = transform.lossyScale;
				var size = sphereCollider.radius * Mathf.Max(scale.x, scale.y, scale.z);
				Gizmos.DrawWireSphere(center, size);
			}
			if (TryGetComponent<BoxCollider2D>(out var boxCollider2D))
			{
				var bounds = boxCollider2D.bounds;
				Gizmos.DrawWireCube(bounds.center, bounds.size);
			}
		}
	}
}