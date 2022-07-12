using UnityEngine;

namespace Events.Channels
{
    [CreateAssetMenu(menuName = "Event Channels/Data Channels/Scene", fileName = "SceneChannel")]
    public class LevelDataContainerChannel : EventChannel<LevelDataContainer> { }
}