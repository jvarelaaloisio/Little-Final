using System;
using System.Collections;
using Cinemachine;
using Core.Providers;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Missions.Implementations
{
    public class PopulateDirector : MonoBehaviour
    {
        [SerializeField] private PlayableDirector playableDirector;
        [SerializeField] private DataProvider<Animator> playerAnimatorProvider;
        [SerializeField] private string playerAnimatorTrackKey = "Animation Track";
        [SerializeField] private string cameraBrainTrackKey = "Cinemachine Track";

        private void OnValidate()
        {
            playableDirector ??= GetComponent<PlayableDirector>();
        }

        private IEnumerator Start()
        {
            if (playerAnimatorProvider == null
                || playableDirector == null)
            {
                yield break;
            }
            yield return new WaitUntil(() => playerAnimatorProvider.Value != null);
            var timelineAsset = playableDirector.playableAsset as TimelineAsset;
            var mainCamera = Camera.main;
            CinemachineBrain camBrain = null;
            if (mainCamera)
                mainCamera.TryGetComponent(out camBrain);
            foreach (var track in timelineAsset.GetOutputTracks())
            {
                if (track.name == playerAnimatorTrackKey)
                {
                    playableDirector.SetGenericBinding(track, playerAnimatorProvider.Value);
                }
                if (track.name == cameraBrainTrackKey && camBrain)
                {
                    playableDirector.SetGenericBinding(track, camBrain);
                }
            }
        }
    }
}
