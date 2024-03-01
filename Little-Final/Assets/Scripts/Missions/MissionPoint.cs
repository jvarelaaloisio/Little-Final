using Core.Interactions;
using Core.Providers;
using UnityEngine;

namespace Missions
{
    public class MissionPoint : Sequence
    {
        [SerializeField] private MissionContainer mission;
        [SerializeField] private DataProvider<MissionsManager> missionsManagerProvider;
        public override void Interact(IInteractor interactor)
        {
            if (missionsManagerProvider.TryGetValue(out var missionsManager))
            {
                missionsManager.AddMission(mission.Get);
            }
            base.Interact(interactor);
        }
    }
}