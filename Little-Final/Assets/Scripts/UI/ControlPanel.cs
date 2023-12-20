using Events.Channels;
using UnityEngine;

namespace UI
{
    public class ControlPanel : MonoBehaviour
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
            if (Input.GetKeyDown(KeyCode.Escape)) Toggle();
        }

        public void Toggle()
        {
            _isOn = !_isOn;
            container.SetActive(_isOn);
            if (pauseChannel) pauseChannel.RaiseEvent(_isOn);
        }
    }
}
