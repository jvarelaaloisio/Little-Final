using System.Collections.Generic;
using System.IO;
using UnityEngine;
using Newtonsoft.Json;

public class SavedData : MonobehaviourSingleton<SavedData>
{
    private const string MIXER_CHANNEL = "/Data/MixerChannels.save";
    private const string GRAPHICS_DATA = "/Data/Graphics.save";

    private Dictionary<string, float> MixerChannelsVolumes => _mixerChannelsVolumes ?? LoadMixerChannelData();
    private Dictionary<string, float> _mixerChannelsVolumes;

    public float GetMixerChannelData(string channel)
    {
        if (MixerChannelsVolumes.ContainsKey(channel))
            return MixerChannelsVolumes[channel];

        SaveMixerChannelData(channel, 0);
        return 0;
    }

    public void SaveMixerChannelData(string channel, float volume)
    {
        MixerChannelsVolumes[channel] = volume;
        var json = JsonConvert.SerializeObject(MixerChannelsVolumes, Formatting.Indented);
        var path = Application.persistentDataPath + MIXER_CHANNEL;
        using (var writer = new StreamWriter(path))
        {
            writer.Write(json);
        }
    }

    private Dictionary<string, float> LoadMixerChannelData()
    {
        var path = Application.persistentDataPath + MIXER_CHANNEL;
        if (!File.Exists(path)) return CreateMixerChannelData(path);

        string json;
        using (var reader = new StreamReader(path))
        {
            json = reader.ReadToEnd();
        }

        var data = JsonConvert.DeserializeObject<Dictionary<string, float>>(json);
        _mixerChannelsVolumes = data ?? new Dictionary<string, float>();

        return _mixerChannelsVolumes;
    }

    private Dictionary<string, float> CreateMixerChannelData(string path)
    {
        var dir = Path.GetDirectoryName(path);
        if (dir != null && !Directory.Exists(dir)) Directory.CreateDirectory(dir);

        _mixerChannelsVolumes = new Dictionary<string, float>();
        var json = JsonConvert.SerializeObject(_mixerChannelsVolumes, Formatting.Indented);
        using (var writer = new StreamWriter(path))
        {
            writer.Write(json);
        }

        return _mixerChannelsVolumes;
    }

    public static GraphicsData GetGraphicsData()
    {
        var path = Application.persistentDataPath + GRAPHICS_DATA;
        return File.Exists(path) ? LoadGraphicsData(path) : CreateGraphicsData(path);
    }

    private static GraphicsData LoadGraphicsData(string path)
    {
        string json;
        using (var reader = new StreamReader(path))
        {
            json = reader.ReadToEnd();
        }

        return JsonConvert.DeserializeObject<GraphicsData>(json);
    }

    private static GraphicsData CreateGraphicsData(string path)
    {
        var dir = Path.GetDirectoryName(path);
        if (dir != null && !Directory.Exists(dir)) Directory.CreateDirectory(dir);

        var graphicsData = new GraphicsData
        {
            isFullScreen = true,
            CurrentResolution = Screen.currentResolution,
            currentQuality = 0
        };

        var json = JsonConvert.SerializeObject(graphicsData, Formatting.Indented);
        using (var writer = new StreamWriter(path))
        {
            writer.Write(json);
        }

        return graphicsData;
    }

    public static void SaveGraphicsData(GraphicsData graphicsData)
    {
        var path = Application.persistentDataPath + GRAPHICS_DATA;
        var json = JsonConvert.SerializeObject(graphicsData, Formatting.Indented);
        using (var writer = new StreamWriter(path))
        {
            writer.Write(json);
        }
    }
}
