using System.Collections.Generic;
using System.Linq;
using Core.Extensions;
using Core.Missions;
using Core.Providers;
using UnityEngine;

namespace Missions
{
    public class MissionsManager : MonoBehaviour
    {
        [SerializeField] private Dictionary<Mission, Status> missions = new();
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
            missions.Add(mission, new Status());
            mission.onComplete += HandleMissionComplete;
            this.Log($"Adding mission {mission.Name}", this);
        }

        public bool HasMission(Mission mission)
            => missions.ContainsKey(mission);

        public void FinishMission(Mission mission)
        {
            if (!HasMission(mission))
                return;
            missions[mission].IsFinished = true;
            mission.Finish();
        }

        public bool TryGetStatus(Mission mission, out Status status)
        {
            return missions.TryGetValue(mission, out status);
        }
        
        private void HandleMissionComplete(Mission mission)
        {
            if (HasMission(mission))
            {
                missions[mission].IsComplete = true;
                this.Log($"Mission {mission.Name} complete!", this);
            }
            else
                this.LogError($"{mission.Name} wasn't added!");
        }

        public class Status
        {
            public bool IsComplete { get; set; } = false;
            public bool IsFinished { get; set; } = false;
        }
    }
}