using System;
using System.Collections.Generic;
using Events.Channels;
using UnityEngine;

namespace Extras
{
    public class ControlParticlesViaChannels : MonoBehaviour
    {
        [SerializeField] private new ParticleSystem particleSystem;
        
        [SerializeField] private List<VoidChannelSo> playWhen = new();
        [SerializeField] private List<VoidChannelSo> stopWhen = new();

        private void OnEnable()
        {
            playWhen.ForEach(channel => channel.SubscribeSafely(Play));
            stopWhen.ForEach(channel => channel.SubscribeSafely(Stop));
        }
        
        private void OnDisable()
        {
            playWhen.ForEach(channel => channel.UnsubscribeSafely(Play));
            stopWhen.ForEach(channel => channel.UnsubscribeSafely(Stop));
        }

        private void Play()
        {
            particleSystem.Play();
        }

        private void Stop()
        {
            particleSystem.Stop();
        }
    }
}
