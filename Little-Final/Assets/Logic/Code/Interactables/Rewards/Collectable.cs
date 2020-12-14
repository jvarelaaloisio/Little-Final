using UnityEngine;
using UpdateManagement;

[SelectionBase]
[RequireComponent(typeof(CollectableRotator))]
[RequireComponent(typeof(Collider))]
public class Collectable : MonoBehaviour
{
	public ParticleSystem idleParticles;
	public float distanceFromGround;
	public float setupTime;
	public Vector3 scaleWhenPicked;
	private CollectableSetup collectableSetup;

	private void Start()
	{
		if(Physics.Raycast(transform.position + Vector3.up/3, Vector3.down, out RaycastHit hit, 10))
		{
			Debug.DrawLine(transform.position, hit.point, Color.green, 1);
			transform.position = hit.point + Vector3.up * distanceFromGround;
		}
	}

	private void OnTriggerEnter(Collider other)
	{
		idleParticles.Stop();
		CollectableBag bag = other.GetComponent<PlayerModel>().collectableBag;
		bag.AddCollectable(GetComponent<CollectableRotator>());
		bag.ValidateNewReward();
		Transform _pivot = other.GetComponent<PlayerModel>().collectablePivot;
		GetComponent<Collider>().enabled = false;
		transform.SetParent(other.transform);
		Destroy(GetComponent<RotateAroundSelf>());
		collectableSetup = new CollectableSetup(GetComponent<CollectableRotator>(), _pivot, scaleWhenPicked, setupTime, OnFinishedSetup);
		collectableSetup.StartSetup();
	}
	private void OnFinishedSetup()
	{
		Destroy(this);
	}

	private void OnDrawGizmos()
	{
		if (Physics.Raycast(transform.position + Vector3.up / 3, Vector3.down, out RaycastHit hit, 10))
		{
			Gizmos.color = Color.green;
			Gizmos.DrawWireSphere(hit.point + Vector3.up * distanceFromGround, .2f);
		}
	}
}
