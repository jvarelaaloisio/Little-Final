using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SongTrigger : MonoBehaviour
{
	public AudioSource songSource;
	private void OnTriggerEnter(Collider other)
	{
		AudioManager _manager = FindObjectOfType<AudioManager>();
		_manager.StopMainMusic();
		songSource.Play();
	}
}
