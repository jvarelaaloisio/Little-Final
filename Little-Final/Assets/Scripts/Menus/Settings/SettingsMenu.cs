using System;
using System.Collections.Generic;
using Menus;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class SettingsMenu : Menu
{
    [Header("Graphics")] 
    public Toggle isFullScreen;
    public TMP_Dropdown resolutions;
    public TMP_Dropdown qualities;
    [Header("Audio")]
    public List<VolumeSlider> volumeSliders;

    private List<IGenericSettings> _settings;

    private void Awake()
    {
        _settings = new List<IGenericSettings>
        {
            new GraphicsSettings(isFullScreen, resolutions, qualities),
            new AudioSettings(volumeSliders),
        };
    }

    protected override void OnEnable()
    {
        foreach (var setting in _settings) setting.Init();
        base.OnEnable();
    }

    private void OnDisable()
    {
        foreach (var setting in _settings) setting.Save();
    }
}

[Serializable]
public struct VolumeSlider
{
    public string channel;
    public Slider slider;
}