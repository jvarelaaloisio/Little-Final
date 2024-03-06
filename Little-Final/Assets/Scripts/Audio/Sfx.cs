using Core.Providers;
using UnityEngine;

namespace Audio
{
    public class Sfx : MonoBehaviour
    {
        [SerializeField] private AudioManager.SoundIndex soundType = AudioManager.SoundIndex.Effect;
        [SerializeField] private DataProvider<AudioManager> audioManagerProvider;
        [SerializeField] private AudioClip[] sfx = {};

        public void Play()
        {
            if (audioManagerProvider.TryGetValue(out var manager))
                manager.Play(sfx[Random.Range(0, sfx.Length)], soundType);
        }
    }
}
