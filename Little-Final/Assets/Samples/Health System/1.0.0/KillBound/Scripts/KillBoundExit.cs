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
            Gizmos.color = new Color(1, 0, 0, 0.25f);
            var position = Vector3.zero;
            
            if (TryGetComponent(out Collider collider))
                position = transform.InverseTransformPoint(collider.bounds.center);
            else if (TryGetComponent(out Collider2D collider2D))
                position = transform.InverseTransformPoint(collider2D.bounds.center);

            var size = Vector3.one;
            
            if (TryGetComponent(out BoxCollider boxCollider))
                size = boxCollider.size;
            else if (TryGetComponent(out SphereCollider sphereCollider))
                size = sphereCollider.bounds.size;
            else if (TryGetComponent(out CapsuleCollider capsuleCollider))
                size = capsuleCollider.bounds.size;
            if (TryGetComponent<MeshFilter>(out var meshFilter))
            {
                Gizmos.matrix = transform.localToWorldMatrix;
                size = meshFilter.sharedMesh.bounds.size;
                Gizmos.DrawWireMesh(meshFilter.sharedMesh, position, Quaternion.identity, size);
            }
        }
    }
}