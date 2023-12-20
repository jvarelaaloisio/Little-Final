using Core.Extensions;
using Events.Channels;
using Menus.Events;
using UnityEngine;

namespace Menus
{
    public class LevelLoader : MonoBehaviour
    {
        [SerializeField] private LevelDataContainerChannel loadLevelChannel;
        [SerializeField] private LevelDataContainerViaBuildIndexes levelContainer;
        [Tooltip("Should this gameObject be destroyed when the level channel's event is risen")]
        [SerializeField] private bool destroyOnLoad;
        
        private void Start()
        {
            loadLevelChannel.RaiseEventSafely(levelContainer);
            this.Log($"Loaded Level [{levelContainer.name}] via [{loadLevelChannel.name}]");
            if (destroyOnLoad)
            {
                Destroy(gameObject);
            }
        }
    }
}