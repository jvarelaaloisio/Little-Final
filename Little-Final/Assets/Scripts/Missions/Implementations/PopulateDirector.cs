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

        private void OnEnable()
        {
            playableDirector.played += HandlePlay;
        }
        private void OnDisable()
        {
            playableDirector.played -= HandlePlay;
        }

        private void HandlePlay(PlayableDirector obj)
        {
            var timelineAsset = playableDirector.playableAsset as TimelineAsset;
            var mainCamera = Camera.main;
            CinemachineBrain camBrain = null;
            if (mainCamera)
                mainCamera.TryGetComponent(out camBrain);
            foreach (var track in timelineAsset.GetOutputTracks())
            {
                if (!string.IsNullOrEmpty(playerAnimatorTrackKey)
                    && track.name == playerAnimatorTrackKey
                    && playerAnimatorProvider.TryGetValue(out var player))
                {
                    playableDirector.SetGenericBinding(track, player);
                }
                if (!string.IsNullOrEmpty(cameraBrainTrackKey) && track.name == cameraBrainTrackKey && camBrain)
                {
                    playableDirector.SetGenericBinding(track, camBrain);
                }
            }
        }

        // private IEnumerator Start()
        // {
        //     if (playerAnimatorProvider == null
        //         || playableDirector == null)
        //     {
        //         yield break;
        //     }
        //     yield return new WaitUntil(() => playerAnimatorProvider.Value != null);
        //     var timelineAsset = playableDirector.playableAsset as TimelineAsset;
        //     var mainCamera = Camera.main;
        //     CinemachineBrain camBrain = null;
        //     if (mainCamera)
        //         mainCamera.TryGetComponent(out camBrain);
        //     foreach (var track in timelineAsset.GetOutputTracks())
        //     {
        //         if (!string.IsNullOrEmpty(playerAnimatorTrackKey) && track.name == playerAnimatorTrackKey)
        //         {
        //             playableDirector.SetGenericBinding(track, playerAnimatorProvider.Value);
        //         }
        //         if (!string.IsNullOrEmpty(cameraBrainTrackKey) && track.name == cameraBrainTrackKey && camBrain)
        //         {
        //             playableDirector.SetGenericBinding(track, camBrain);
        //         }
        //     }
        // }
    }
}
