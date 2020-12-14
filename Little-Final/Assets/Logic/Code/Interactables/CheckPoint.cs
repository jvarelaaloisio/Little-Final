using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{
	public float distanceFromFloor;
	public Vector3 safePoint;
	private void OnTriggerEnter(Collider other)
	{
		other.GetComponent<PlayerModel>().SaveSafePosition(safePoint);
	}
	private void OnDrawGizmos()
	{
		Gizmos.color = Color.blue;
		Gizmos.DrawWireSphere(safePoint, .2f);
	}
}
