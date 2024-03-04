using System.Collections.Generic;
using Core.Extensions;
using Core.Providers;
using UnityEngine;

namespace Missions
{
    public class MissionsManager : MonoBehaviour
    {
        [SerializeField] private List<Mission> missions = new();
        [SerializeField] private DataProvider<MissionsManager> provider;
        

        private void OnEnable()
        {
            provider.TrySetValue(this);
        }

        private void OnDisable()
        {
            if (provider.TryGetValue(out var value)
                && value == this)
                provider.Value = null;
        }

        public void AddMission(Mission mission)
        {
            missions.Add(mission);
            mission.onComplete += HandleMissionComplete;
            this.Log($"Adding mission {mission.Name}", this);
        }

        private void HandleMissionComplete(Mission mission)
        {
            missions.Remove(mission);
            this.Log($"Mission {mission.Name} complete!", this);
        }
    }
}