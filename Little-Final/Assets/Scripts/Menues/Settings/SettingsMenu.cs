using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SettingsMenu : MonoBehaviour
{
    public List<VolumeSlider> volumeSliders;

    public void OnEnable()
    {
        InitAudioSettings();
    }

    private void OnDisable()
    {
        SaveAudioSettings();
    }

    private void InitAudioSettings()
    {
        foreach (var entry in volumeSliders)
        {
            entry.slider.value = SavedData.Instance.GetMixerChannelData(entry.channel);

            entry.slider.onValueChanged.AddListener(
                value => SettingsManager.Instance.SetChannelVolume(entry.channel, value)
            );
        }
    }

    private void SaveAudioSettings()
    {
        foreach (var entry in volumeSliders)
            SavedData.Instance.SaveMixerChannelData(entry.channel, entry.slider.value);
    }
}

[Serializable]
public struct VolumeSlider
{
    public string channel;
    public Slider slider;
}