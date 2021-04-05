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
	private bool _isWalkPlaying,
		_isFlyPlaying;
	void Start()
	{
		model = GetComponent<PlayerModel>();
		audioManager = FindObjectOfType<AudioManager>();
	}
	public void PlayJump()
	{
		loopingSfx.Stop();
		_isWalkPlaying = false;
		_isFlyPlaying = false;
		audioManager?.PlayCharacterSound(jump);
	}
	public void PlayWalk()
	{
		if (_isWalkPlaying)
			return;
		_isWalkPlaying = true;
		loopingSfx.clip = walk;
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
}