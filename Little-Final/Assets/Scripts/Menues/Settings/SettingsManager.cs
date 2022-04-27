using UnityEngine;
using UnityEngine.Audio;

public class SettingsManager : MonobehaviourSingleton<SettingsManager>
{
    private AudioMixer _mixer;

    private void OnEnable()
    {
        _mixer = Resources.Load<AudioMixer>("Audio/MainMixer");
    }

    public void SetChannelVolume(MixerChannels channel, float volume)
    {
        _mixer.SetFloat(channel.ToString(), volume);
    }
}

public enum MixerChannels
{
    MasterVolume,
    MusicVolume,
    AmbientVolume,
    CharacterVolume,
    SFXVolume,
    BGVolume,
    CutsceneVolume
}