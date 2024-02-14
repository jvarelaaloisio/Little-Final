using System;
using Core.Extensions;
using UnityEngine;

namespace Player.PlayerInput
{
    public class ControlCameraPitch : MonoBehaviour
    {
        [Header("Bounds")]
        [SerializeField] private float upperBound = 1;
        [SerializeField] private float lowerBound = -1;
        
        [Header("Setup")]
        [ContextMenuItem("Set to current position", nameof(ResetOriginToCurrentPosition))]
        [SerializeField] private float origin = 0;
        [SerializeField] private float movementSpeed = 1;
        [SerializeField] private bool autoRecenter;
        
        private void Update()
        {
            if (Input.GetKey(KeyCode.J))
            {
                ResetToOrigin();
            }
            var dir = InputManager.GetCameraYInput();
            var vel = dir * movementSpeed * Time.deltaTime;
            if (vel == 0
                || vel > 0 && WillSurpassUpperBound()
                || vel < 0 && WillSurpassLowerBound())
            {
                return;
            }
            transform.Translate(0, vel, 0, Space.Self);

            bool WillSurpassUpperBound()
            {
                return transform.localPosition.y >= upperBound;
            }

            bool WillSurpassLowerBound()
            {
                return transform.localPosition.y <= lowerBound;
            }
        }

        public void ResetOriginToCurrentPosition()
        {
            origin = transform.localPosition.y;
        }

        [ContextMenu("Reset to origin")]
        public void ResetToOrigin()
        {
            transform.localPosition = transform.localPosition.ReplaceY(origin);
        }
    }
}
