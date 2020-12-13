using UnityEngine;
using UpdateManagement;

[RequireComponent(typeof(CollectableRotator))]
[RequireComponent(typeof(Collider))]
public class Collectable : MonoBehaviour
{
	public float setupTime;
	public Vector3 scaleWhenPicked;
	private CollectableSetup collectableSetup;

	private void OnTriggerEnter(Collider other)
	{
		CollectableBag bag = other.GetComponent<PlayerModel>().collectableBag;
		bag.AddCollectable(GetComponent<CollectableRotator>());
		bag.ValidateNewReward();

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
