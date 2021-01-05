using UnityEngine;
[RequireComponent(typeof(PlayerModel))]
public class PlayerSound : MonoBehaviour
{
	public AudioClip walk,
					jump,
					fly;
	public AudioSource loopingSfx;
	AudioManager audioManager;
	private PlayerModel model;
	private bool isWalkPlaying,
		isflyPlaying;
	void Start()
	{
		model = GetComponent<PlayerModel>();
		audioManager = FindObjectOfType<AudioManager>();
	}
	public void PlayJump()
	{
		loopingSfx.Stop();
		isWalkPlaying = false;
		isflyPlaying = false;
		audioManager.PlayCharacterSound(jump);
	}
	public void PlayWalk()
	{
		if (!isWalkPlaying)
		{
			isWalkPlaying = true;
			loopingSfx.clip = walk;
			loopingSfx.Play();
		}
	}
	public void StopWalk()
	{
		loopingSfx.Stop();
		isWalkPlaying = false;
	}
	public void PlayFly()
	{
		if (!isflyPlaying)
		{
			isflyPlaying = true;
			loopingSfx.clip = fly;
			loopingSfx.Play();
		}
	}
	public void StopFly()
	{
		loopingSfx.Stop();
		isflyPlaying = false;
	}
}