using System.Collections.Generic;
using UnityEngine;

public class SavedData : MonobehaviourSingleton<SavedData>
{
    private Dictionary<MixerChannels, float> MixerChannelsVolumes => _mixerChannelsVolumes ?? LoadMixerChannelData();
    private Dictionary<MixerChannels, float> _mixerChannelsVolumes;
    
    public float GetMixerChannelData(MixerChannels channel)
    {
        if (MixerChannelsVolumes.ContainsKey(channel))
            return MixerChannelsVolumes[channel];

        SaveMixerChannelData(channel, 0);
        return 0;
    }

    public static void SaveMixerChannelData(MixerChannels channel, float volume)
    {
    }

    private Dictionary<MixerChannels,float> LoadMixerChannelData()
    {
        var data = Resources.Load<TextAsset>("Data/MixerChannelData");
        
        return new Dictionary<MixerChannels, float>();
    }
}
