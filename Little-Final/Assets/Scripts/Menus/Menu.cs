using System;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Menus
{
    public class Menu : MonoBehaviour
    {
        [SerializeField] private GameObject defaultSelection;
        [SerializeField] private string horizontalAxis  = "Horizontal";
        [SerializeField] private string verticalAxis = "Vertical";
        private GameObject _lastSelection;
        private EventSystem _eventSystem;

        protected virtual void OnEnable()
        {
            _eventSystem = EventSystem.current;
            if (!_eventSystem)
            {
                enabled = false;
                return;
            }
            if (defaultSelection)
                _eventSystem.SetSelectedGameObject(defaultSelection);
        }

        protected virtual void Update()
        {
            var currentSelection = _eventSystem.currentSelectedGameObject;
            if (!currentSelection
                && (Mathf.Abs(Input.GetAxis(horizontalAxis)) > 0
                    || Mathf.Abs(Input.GetAxis(verticalAxis)) > 0))
            {
                _eventSystem.SetSelectedGameObject(_lastSelection);
            }
            if (currentSelection != null && currentSelection != _lastSelection)
            {
                _lastSelection = currentSelection;
            }
        }
    }
}