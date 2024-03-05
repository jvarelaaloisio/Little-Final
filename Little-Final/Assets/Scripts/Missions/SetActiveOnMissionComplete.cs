using UnityEngine;

namespace Missions
{
    public class SetActiveOnMissionComplete : MonoBehaviour
    {
        [SerializeField] private MissionContainer mission;
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
            gameObject.SetActive(active);
        }
    }
}