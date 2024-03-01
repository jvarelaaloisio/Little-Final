using System;
using Events.Channels;
using UnityEngine;

namespace UI
{
    public class ItemIconsView : MonoBehaviour
    {
        [SerializeField] private GameObject iconPrefab;
        [SerializeField] private IntEventChannel setIconsChannel;

        private void OnEnable()
        {
            setIconsChannel.SubscribeSafely(HandleIconsChange);
        }

        private void OnDisable()
        {
            setIconsChannel.UnsubscribeSafely(HandleIconsChange);
        }

        private void HandleIconsChange(int qty)
        {
            
        }
    }
}
