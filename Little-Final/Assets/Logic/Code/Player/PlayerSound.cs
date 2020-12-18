using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;
public class PlayerSound : MonoBehaviour, ILateUpdateable
{
	public AudioClip walk,
					jump,
					fall,
					fly;
	AudioManager audioManager;
	void Start()
    {
        UpdateManager.Subscribe(this);
		audioManager = FindObjectOfType<AudioManager>();
    }
	public void OnLateUpdate()
	{
		audioManager.PlayCharacterSound(walk);
	}
}
