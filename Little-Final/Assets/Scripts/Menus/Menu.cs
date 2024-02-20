using System;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Menus
{
    public class Menu : MonoBehaviour
    {
        [SerializeField] private GameObject defaultSelection;

        protected virtual void OnEnable()
        {
            if (defaultSelection && EventSystem.current)
                EventSystem.current.SetSelectedGameObject(defaultSelection);
        }
    }
}
