using UnityEngine;

namespace UI
{
    public class ControlPanel : MonoBehaviour
    {
        [SerializeField] private GameObject container;

        private bool _isOn = false;

        private void Awake()
        {
            container.SetActive(_isOn);
        }

        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.Escape)) Toggle();
        }

        private void Toggle()
        {
            _isOn = !_isOn;
            container.SetActive(_isOn);
        }
    }
}
