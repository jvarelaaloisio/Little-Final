using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;

[RequireComponent(typeof(MeshRenderer))]
public class CollectableRotator : MonoBehaviour, IUpdateable
{
	public ParticleSystem rewardParticles;
	public Transform pivot;
	public Vector3 amplitude,
				frecuency;
	private float t;
	private void Start()
	{
		UpdateManager.Instance.Subscribe(this);
		t = 0;
	}

	public void OnUpdate()
	{
		transform.position = GetPosition(t);
		t += Time.deltaTime;
		if (t >= Mathf.PI * 2)
			t = 0;
	}

	public Vector3 GetPosition(float t)
	{
		return pivot.position + (Vector3.right * Mathf.Cos(t * frecuency.x) * amplitude.x) + (Vector3.up * Mathf.Sin(t * frecuency.y) * amplitude.y) + (Vector3.forward * Mathf.Sin(t * frecuency.z) * amplitude.z);
	}

	public void OnRewardGiven()
	{
		rewardParticles.Play();
		GetComponent<MeshRenderer>().enabled = false;
		new CountDownTimer(rewardParticles.main.startLifetime.constantMax, () => Destroy(this.gameObject)).StartTimer();
	}
	private void OnDestroy()
	{
		UpdateManager.Instance.UnSubscribe(this);
	}
}
