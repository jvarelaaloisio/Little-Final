using UnityEngine;
using UnityEngine.Audio;

public class SettingsManager : MonobehaviourSingleton<SettingsManager>
{
    private AudioMixer _mixer;

    private void OnEnable()
    {
        _mixer = Resources.Load<AudioMixer>("Audio/MainMixer");
    }

    public void SetChannelVolume(string channel, float volume)
    {
        _mixer.SetFloat(channel, volume);
    }
}
