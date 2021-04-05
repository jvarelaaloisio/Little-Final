using UnityEngine;

[SelectionBase]
[RequireComponent(typeof(CollectableRotator))]
[RequireComponent(typeof(Collider))]
public class Collectable : MonoBehaviour
{
	public ParticleSystem idleParticles;
	public float setupTime;
	public Vector3 scaleWhenPicked;
	private CollectableSetup collectableSetup;
	public float distanceFromGround;
	public bool isRePositioningAtStart;
	private int _sceneIndex;
	private void Start()
	{
		_sceneIndex = gameObject.scene.buildIndex;
		if(isRePositioningAtStart
		   && Physics.Raycast(
			   transform.position + Vector3.up/3,
			   Vector3.down,
			   out RaycastHit hit,
			   10))
		{
			Debug.DrawLine(transform.position, hit.point, Color.red, 1);
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
		collectableSetup =
			new CollectableSetup(
				GetComponent<CollectableRotator>(),
				_pivot,
				scaleWhenPicked,
				setupTime,
				OnFinishedSetup,
				_sceneIndex);
		collectableSetup.StartSetup();
	}
	private void OnFinishedSetup()
	{
		Destroy(this);
	}

	private void OnDrawGizmos()
	{
		if (isRePositioningAtStart
		    && Physics.Raycast(
			    transform.position + Vector3.up / 3,
			    Vector3.down,
			    out RaycastHit hit,
			    10))
		{
			Gizmos.color = Color.red;
			Gizmos.DrawWireSphere(hit.point + Vector3.up * distanceFromGround, .2f);
		}
	}
}
