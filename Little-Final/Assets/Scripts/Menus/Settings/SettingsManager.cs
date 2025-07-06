using UnityEngine;
using UnityEngine.Audio;

public class SettingsManager : MonobehaviourSingleton<SettingsManager>
{
    [SerializeField] private bool shouldLogSystemInfo;
    
    private AudioMixer _mixer;

    private void OnEnable()
    {
        if (shouldLogSystemInfo)
            Debug.Log("Active GPU: " + SystemInfo.graphicsDeviceName);
        _mixer = Resources.Load<AudioMixer>("Audio/MainMixer");
    }

    public void SetChannelVolume(string channel, float volume)
    {
        _mixer.SetFloat(channel, volume);
    }
}
