using Events.Channels;
using UnityEngine;

namespace Menus
{
    public class ControlPanel : Menu
    {
        [SerializeField] private GameObject container;

        [SerializeField]
        private BoolEventChannel pauseChannel;

        private bool _isOn = false;

        private void Awake()
        {
            container.SetActive(_isOn);
        }

        private void Update()
        {
            if (Input.GetButtonDown("Pause")) Toggle();
        }

        public void Toggle()
        {
            _isOn = !_isOn;
            container.SetActive(_isOn);
            pauseChannel.RaiseEventSafely(_isOn);
        }
    }
}
