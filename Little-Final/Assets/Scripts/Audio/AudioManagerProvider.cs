using Core.Providers;
using UnityEngine;

namespace Audio
{
    [CreateAssetMenu(menuName = "Data/Providers/Audio Manager", fileName = "AudioManagerProvider", order = 0)]
    public class AudioManagerProvider : DataProvider<AudioManager> { }
}
