using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SfxTrigger : MonoBehaviour
{
	public AudioClip[] sfx;

	public void Trigger()
	{
		FindObjectOfType<AudioManager>()?.PlayEffect(sfx[Random.Range(0, sfx.Length)]);
	}
	private void OnTriggerEnter(Collider other)
	{
		Trigger();
	}
}
