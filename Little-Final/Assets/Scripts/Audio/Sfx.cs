using Core.Providers;
using UnityEngine;

namespace Audio
{
    public class Sfx : MonoBehaviour
    {
        [SerializeField] private DataProvider<AudioManager> audioManagerProvider;
        [SerializeField] private AudioClip[] sfx = {};

        public void Play()
        {
            if (audioManagerProvider.TryGetValue(out var manager))
                manager.PlayEffect(sfx[Random.Range(0, sfx.Length)]);
        }
    }
}
