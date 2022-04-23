using System.Collections.Generic;
using System.IO;
using UnityEngine;
using Newtonsoft.Json;

public class SavedData : MonobehaviourSingleton<SavedData>
{
    private const string MIXER_CHANNEL = "/Data/MixerChannels.save";
    private Dictionary<MixerChannels, float> MixerChannelsVolumes => _mixerChannelsVolumes ?? LoadMixerChannelData();
    private Dictionary<MixerChannels, float> _mixerChannelsVolumes;

    public float GetMixerChannelData(MixerChannels channel)
    {
        if (MixerChannelsVolumes.ContainsKey(channel))
            return MixerChannelsVolumes[channel];

        SaveMixerChannelData(channel, 0);
        return 0;
    }

    public void SaveMixerChannelData(MixerChannels channel, float volume)
    {
        MixerChannelsVolumes[channel] = volume;
        var json = JsonConvert.SerializeObject(MixerChannelsVolumes, Formatting.Indented);
        var path = Application.persistentDataPath + MIXER_CHANNEL;
        using (var writer = new StreamWriter(path))
        {
            writer.Write(json);
        }

        print(json);
    }

    private Dictionary<MixerChannels, float> LoadMixerChannelData()
    {
        var path = Application.persistentDataPath + MIXER_CHANNEL;
        if (!File.Exists(path)) return CreateMixerChannelData(path);

        string json;
        using (var reader = new StreamReader(path))
        {
            json = reader.ReadToEnd();
        }

        var data = JsonConvert.DeserializeObject<Dictionary<MixerChannels, float>>(json);
        _mixerChannelsVolumes = data ?? new Dictionary<MixerChannels, float>();

        return _mixerChannelsVolumes;
    }

    private Dictionary<MixerChannels, float> CreateMixerChannelData(string path)
    {
        var dir = Path.GetDirectoryName(path);
        if (dir != null && !Directory.Exists(dir)) Directory.CreateDirectory(dir);

        _mixerChannelsVolumes = new Dictionary<MixerChannels, float>();
        var json = JsonConvert.SerializeObject(_mixerChannelsVolumes, Formatting.Indented);
        using (var writer = new StreamWriter(path))
        {
            writer.Write(json);
        }

        return _mixerChannelsVolumes;
    }
}
