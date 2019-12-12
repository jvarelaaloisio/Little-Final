using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Collider))]
public class Wind : MonoBehaviour
{
	#region Variables

	#region Serialized
	[SerializeField]
	float force;
	#endregion

	#endregion

	#region Unity
	void Start()
	{
		GetComponent<Collider>().isTrigger = true;
		GetComponentInChildren<ParticleSystem>().Play();
	}
	#endregion

	#region Collisions
	private void OnTriggerStay(Collider other)
	{
		IBody characterBody = other.GetComponent<IBody>();
		if (characterBody == null) return;
		characterBody.Push(transform.up, force);
	}
	#endregion

	#region Gizmos
	private void OnDrawGizmos()
	{
		Vector3 pos = GetComponentInChildren<ParticleSystem>().transform.position;
		Gizmos.color = Color.blue;
		Gizmos.DrawWireSphere(pos, .5f);
		Gizmos.DrawLine(pos, pos + transform.up * transform.localScale.y);
	}
	#endregion
}
