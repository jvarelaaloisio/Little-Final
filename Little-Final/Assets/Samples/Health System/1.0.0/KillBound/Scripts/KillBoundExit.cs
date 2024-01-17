using System;
using HealthSystem.Runtime.Helpers;
using UnityEngine;

namespace HealthSystem.Runtime.Components.Damage
{
    [Tooltip("Component that kills anything that exits it")]
    public class KillBoundExit : MonoBehaviour
    {
        protected void OnTriggerExit(Collider other) => other.TryToKill();

        private void OnTriggerExit2D(Collider2D other) => other.TryToKill();

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