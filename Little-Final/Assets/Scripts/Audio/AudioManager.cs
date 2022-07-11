using System;
using UnityEngine;
using UnityEngine.Audio;
using VarelaAloisio.UpdateManagement.Runtime;
using Random = UnityEngine.Random;

public class AudioManager : MonoBehaviour
{
	#region Variables
	readonly float[] relations = { 25, 75 };

	enum SoundIndex
	{
		Music,
		Ambient1,
		Ambient2,
		AmbientBG,
		Character,
		Effect
	}

	public AudioClip[] MainTracks;

	public float minSilentTime,
				maxSilentTime;
	public float minSongRandomCut,
				maxSongRandomCut;
	AudioSource[] Sources;
	public AudioMixer Mixer;
	public AudioMixerSnapshot[] SnapshotsVolDown, SnapshotsVolUp;
	private CountDownTimer randomCut;
	private CountDownTimer playNextSong;
	private int _sceneIndex;

	#endregion

	#region Unity
	void Start()
	{
		_sceneIndex = gameObject.scene.buildIndex;
		randomCut = new CountDownTimer(Random.Range(minSongRandomCut, maxSongRandomCut), CutMusic, _sceneIndex);
		Sources = GetComponentsInChildren<AudioSource>();
		SelectMainMusic();
	}

	private void OnDestroy()
	{
		randomCut.StopTimer();
		playNextSong.StopTimer();
	}

	#endregion

	#region Private

	void SelectMainMusic()
	{
		int _musicTrack = Random.Range(0, MainTracks.Length);
		PlayMainMusic(MainTracks[_musicTrack]);
		float _waitTime = MainTracks[_musicTrack].length + Random.Range(minSilentTime, maxSilentTime);
		playNextSong = new CountDownTimer(_waitTime, SelectMainMusic, _sceneIndex);
		if (MainTracks[_musicTrack].length > minSongRandomCut)
			randomCut.StartTimer();
		else
			playNextSong.StartTimer();
		//Invoke("SelectMainMusic", _waitTime);
	}
	private void CutMusic()
	{
		Debug.Log("Cut");
		Sources[(int)SoundIndex.Music].Stop();
		if (playNextSong.IsTicking)
		{
			playNextSong.StopTimer();
			playNextSong = new CountDownTimer(Random.Range(minSilentTime, maxSilentTime), SelectMainMusic, _sceneIndex);
			playNextSong.StartTimer();
		}
	}
	/// <summary>
	/// Controls the BGM
	/// </summary>
	/// <param name="Index"></param>
	/// <param name="Track"></param>
	public void PlayMainMusic(AudioClip Track)
	{
		Sources[(int)SoundIndex.Music].clip = Track;
		Sources[(int)SoundIndex.Music].Play();
	}
	public void StopMainMusic()
	{
		playNextSong.StopTimer();
		randomCut.StopTimer();
		Sources[(int)SoundIndex.Music].Stop();
	}
	#endregion

	#region Public

	/// <summary>
	/// Plays a given sound trhough one of the Ambient sources source
	/// </summary>
	/// <param name="NewClip"></param>
	public void PlayAmbientSound(AudioClip NewClip)
	{
		if (Sources[(int)SoundIndex.Ambient1].isPlaying)
		{
			Sources[(int)SoundIndex.Ambient2].PlayOneShot(NewClip);
		}
		else
		{
			Sources[(int)SoundIndex.Ambient1].PlayOneShot(NewClip);
		}
	}

	/// <summary>
	/// Plays a given sound trhough the Character source
	/// </summary>
	/// <param name="NewClip"></param>
	public void PlayCharacterSound(AudioClip NewClip)
	{
		Sources[(int)SoundIndex.Character].PlayOneShot(NewClip);
	}
	public void PlayEffect(AudioClip NewClip)
	{
		Sources[(int)SoundIndex.Effect].PlayOneShot(NewClip);
	}

	/// <summary>
	/// Turns Volume Down
	/// </summary>
	public void VolumeDown()
	{
		Mixer.TransitionToSnapshots(SnapshotsVolDown, relations, 0f);
	}

	/// <summary>
	/// Turns Volume Up
	/// </summary>
	public void VolumeUp()
	{
		Mixer.TransitionToSnapshots(SnapshotsVolUp, relations, 0f);
	}
	#endregion

	#region Gizmos
	private void OnDrawGizmos()
	{
		Gizmos.color = Color.red;
		Gizmos.DrawSphere(transform.position, .5f);
	}
	#endregion
}