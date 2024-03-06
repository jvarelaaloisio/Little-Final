using Core.Missions;
using UnityEngine;

namespace Missions
{
    public class SetActiveOnMissionComplete : MonoBehaviour
    {
        [SerializeField] private MissionContainer mission;
        [SerializeField] private GameObject controlledGO;
        [SerializeField] private bool active;

        private void OnEnable()
        {
            mission.Get.onComplete += HandleMissionComplete;
        }
        
        private void OnDisable()
        {
            mission.Get.onComplete -= HandleMissionComplete;
        }

        private void HandleMissionComplete(Mission obj)
        {
            if (controlledGO)
                controlledGO.SetActive(active);
        }
    }
}