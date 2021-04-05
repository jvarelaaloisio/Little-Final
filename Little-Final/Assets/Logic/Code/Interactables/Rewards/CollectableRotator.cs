using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

[RequireComponent(typeof(MeshRenderer))]
public class CollectableRotator : MonoBehaviour, IUpdateable
{
	public ParticleSystem rewardParticles;
	public float destructionDelay;
	public Transform pivot;

	public Vector3 amplitude,
		frecuency;

	private float t;
	private bool isRewarded;
	private int _sceneIndex;

	private void Start()
	{
		UpdateManager.Subscribe(this);
		t = 0;
		_sceneIndex = gameObject.scene.buildIndex;
	}

	public void OnUpdate()
	{
		if (isRewarded)
		{
			transform.position = pivot.position;
			return;
		}

		transform.position = GetPosition(t);
		t += Time.deltaTime;
		if (t >= Mathf.PI * 2)
			t = 0;
	}

	public Vector3 GetPosition(float t)
	{
		return pivot.position + (Vector3.right * Mathf.Cos(t * frecuency.x) * amplitude.x)
		                      + (Vector3.up * Mathf.Sin(t * frecuency.y) * amplitude.y)
		                      + (Vector3.forward * Mathf.Sin(t * frecuency.z) * amplitude.z);
	}

	public void OnRewardGiven()
	{
		rewardParticles.Play();
		GetComponent<MeshRenderer>().enabled = false;
		transform.SetParent(null);
		new CountDownTimer(
			destructionDelay,
			() => Destroy(gameObject),
			_sceneIndex).StartTimer();
		isRewarded = true;
	}

	private void OnDestroy()
	{
		UpdateManager.UnSubscribe(this);
	}
}