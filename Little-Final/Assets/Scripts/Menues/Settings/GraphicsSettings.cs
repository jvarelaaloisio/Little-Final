using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class GraphicsSettings : IGenericSettings
{
    private readonly Toggle _fullScreenToggle;
    private readonly TMP_Dropdown _resolutionsDropdown;
    private readonly TMP_Dropdown _qualitiesDropdown;

    private GraphicsData _graphicsData;
    private bool _isInit;

    public GraphicsSettings(Toggle fullScreenToggle, TMP_Dropdown resolutionsDropdown, TMP_Dropdown qualitiesDropdown)
    {
        _fullScreenToggle = fullScreenToggle;
        _resolutionsDropdown = resolutionsDropdown;
        _qualitiesDropdown = qualitiesDropdown;
    }

    public void Init()
    {
        if (_isInit) return;

        _graphicsData = SavedData.GetGraphicsData();

        _fullScreenToggle.isOn = _graphicsData.isFullScreen;
        _fullScreenToggle.onValueChanged.AddListener(value =>
        {
            _graphicsData.isFullScreen = value;
            Screen.fullScreen = value;
        });

        _resolutionsDropdown.ClearOptions();

        var resolutions = Screen.resolutions;
        var options = new List<string>();
        var currentResolution = _graphicsData.CurrentResolution;
        var currentResolutionIndex = 0;
        for (var index = 0; index < resolutions.Length; index++)
        {
            var resolution = resolutions[index];
            options.Add($"{resolution.width}x{resolution.height}");

            if (resolution.width == currentResolution.width && resolution.height == currentResolution.height)
                currentResolutionIndex = index;
        }

        _resolutionsDropdown.AddOptions(options);
        _resolutionsDropdown.value = currentResolutionIndex;
        _resolutionsDropdown.RefreshShownValue();

        _resolutionsDropdown.onValueChanged.AddListener(value =>
        {
            var res = resolutions[value];
            _graphicsData.CurrentResolution = res;
            Screen.SetResolution(res.width, res.height, Screen.fullScreen);
        });

        _qualitiesDropdown.value = _graphicsData.currentQuality;
        _qualitiesDropdown.onValueChanged.AddListener(value =>
        {
            _graphicsData.currentQuality = value;
            QualitySettings.SetQualityLevel(value);
        });

        _isInit = true;
    }

    public void Save()
    {
        SavedData.SaveGraphicsData(_graphicsData);
    }
}

[Serializable]
public struct GraphicsData
{
    public bool isFullScreen;
    public Resolution CurrentResolution;
    public int currentQuality;
}