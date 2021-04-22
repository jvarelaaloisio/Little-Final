using UnityEngine;

public class AmbientAudioTrigger : MonoBehaviour
{
	#region Variables

	#region Public
	public AudioClip[] AmbientSounds;
	public float silencePeriodMin, silencePeriodMax;
	#endregion

	#region Private;
	AudioManager AManager;
	#endregion
	#endregion

	#region Unity
	void Start()
    {
		AManager = GetComponent<AudioManager>();
		Invoke("PlayRandomSound", Random.Range(silencePeriodMin, silencePeriodMax));	
	}
	#endregion

	#region Private
	void PlayRandomSound()
	{
		AManager.PlayAmbientSound(AmbientSounds[Random.Range(0, AmbientSounds.Length)]);
		Invoke("PlayRandomSound", Random.Range(silencePeriodMin, silencePeriodMax));
	}
	#endregion

	#region Public

	#endregion
}
