using System.Collections.Generic;
using Core.Debugging;
using Player;
using UnityEngine;

[RequireComponent(typeof(PlayerController))]
public class PlayerSound : MonoBehaviour
{
	public AudioClip walk,
		fly;

	[SerializeField]
	private AudioClip[] jumpSfx;
	[SerializeField]
	private AudioClip[] walkSfx;


	public AudioSource loopingSfx;
	AudioManager audioManager;

	private bool _isWalkPlaying,
		_isFlyPlaying;

	[Header("Debug")]
	[SerializeField]
	private Debugger debugger;

	void Start()
	{
		GetComponent<PlayerController>();
		audioManager = FindObjectOfType<AudioManager>();
	}

	public void PlayJump()
	{
		loopingSfx.Stop();
		_isWalkPlaying = false;
		_isFlyPlaying = false;
		if (jumpSfx.Length < 1)
			debugger.LogError(transform.name, $"No jump sfx were supplied");
		else
			audioManager?.PlayCharacterSound(jumpSfx[Random.Range(0, jumpSfx.Length - 1)]);
	}

	public void PlayWalk()
	{
		if (_isWalkPlaying)
			return;
		_isWalkPlaying = true;
		if (walkSfx.Length < 1)
			debugger.LogError(transform.name, $"No walk sfx were supplied");
		else
			loopingSfx.clip = walkSfx[Random.Range(0, walkSfx.Length - 1)];
		// loopingSfx.clip = walk;
		loopingSfx.Play();
	}

	public void StopWalk()
	{
		loopingSfx.Stop();
		_isWalkPlaying = false;
	}

	public void PlayFly()
	{
		if (!_isFlyPlaying)
		{
			_isFlyPlaying = true;
			loopingSfx.clip = fly;
			loopingSfx.Play();
		}
	}

	public void StopFly()
	{
		loopingSfx.Stop();
		_isFlyPlaying = false;
	}

	// private IEnumerator PlayWalkLook()
	// {
	// 	
	// }
}

// public static class EnumerableExtensions
// {
// 	public static T GetRandom<T>(IEnumerable<T> enumerable)
// 	{
// 		int length = enumerable.
// 	}
// }