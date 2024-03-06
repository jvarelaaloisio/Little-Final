using Core.Missions;
using UnityEngine;

namespace Missions
{
    public class SetActiveOnMissionComplete : MonoBehaviour
    {
        [SerializeField] private MissionContainer mission;
        [SerializeField] private bool activeByDefault = true;
        [SerializeField] private bool active;

        private void OnEnable()
        {
            if (!activeByDefault)
            {
                gameObject.SetActive(false);
            }
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