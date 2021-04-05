using System.Collections.Generic;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

[RequireComponent(typeof(Collider))]
public class Wind : MonoBehaviour
{
	#region Variables

	#region Serialized
	[SerializeField]
	float force,
		pushPeriod;
	List<IBody> bodies;
	CountDownTimer pushTimer;
	#endregion

	#endregion

	#region Unity
	void Start()
	{
		GetComponent<Collider>().isTrigger = true;
		GetComponentInChildren<ParticleSystem>().Play();
		bodies = new List<IBody>();
		pushTimer = new CountDownTimer(pushPeriod, PushBodies, gameObject.scene.buildIndex);
	}
	#endregion

	#region Private
	private void PushBodies()
	{
		bodies.ForEach(x => x.Push(transform.up, force));
		pushTimer.StartTimer();
	}
	#endregion

	#region Collisions
	private void OnTriggerEnter(Collider other)
	{
		IBody characterBody = other.GetComponent<IBody>();
		if (bodies.Exists(x => x.GameObject.Equals(characterBody.GameObject)))
			return;
		bodies.Add(characterBody);
		if (!pushTimer.IsTicking)
			pushTimer.StartTimer();
	}

	private void OnTriggerExit(Collider other)
	{
		bodies.Remove(other.GetComponent<IBody>());
		if (bodies.Count <= 0)
			pushTimer.StopTimer();
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