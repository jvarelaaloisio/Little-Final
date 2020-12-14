using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class InvisibleWall : MonoBehaviour
{
	private void OnDrawGizmos()
	{
		BoxCollider _myCollider = GetComponent<BoxCollider>();
		Gizmos.color = new Color(1, 1, 1, 0.1f);
		Gizmos.DrawCube(_myCollider.bounds.center, _myCollider.bounds.size);
	}
}
