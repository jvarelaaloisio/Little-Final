using System.Collections.Generic;

public class AudioSettings : IGenericSettings
{
    private List<VolumeSlider> _volumeSliders;
    private bool _isInit;

    public AudioSettings(List<VolumeSlider> volumeSliders)
    {
        _volumeSliders = volumeSliders;
    }

    public void Init()
    {
        if (_isInit) return;

        foreach (var entry in _volumeSliders)
        {
            entry.slider.value = SavedData.Instance.GetMixerChannelData(entry.channel);

            entry.slider.onValueChanged.AddListener(
                value => SettingsManager.Instance.SetChannelVolume(entry.channel, value)
            );
        }

        _isInit = true;
    }

    public void Save()
    {
        foreach (var entry in _volumeSliders)
            SavedData.Instance.SaveMixerChannelData(entry.channel, entry.slider.value);
    }
}