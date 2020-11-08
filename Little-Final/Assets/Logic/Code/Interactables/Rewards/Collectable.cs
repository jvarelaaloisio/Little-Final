using UnityEngine;
using UpdateManagement;

[RequireComponent(typeof(Collider))]
public class Collectable : MonoBehaviour
{
	public float setupTime;
	public Vector3 scaleWhenPicked;
	private CollectableSetup collectableSetup;

	private void OnTriggerEnter(Collider other)
	{
		GetComponent<Collider>().enabled = false;
		transform.SetParent(other.transform);
		Destroy(GetComponent<RotateAroundSelf>());
		collectableSetup = new CollectableSetup(GetComponent<CollectableRotator>(), scaleWhenPicked, setupTime, OnFinishedSetup);
		collectableSetup.StartSetup();
	}
	private void OnFinishedSetup()
	{
		Destroy(this);
	}
}
