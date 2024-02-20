using System.Collections;
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
        [Header("Recenter")]
        [SerializeField] private bool autoRecenter;
        [SerializeField] private float recenterAfter;
        [SerializeField] private float recenterDuration;
        private float _lastInputTime = 0;

        private void OnEnable()
        {
            StartCoroutine(ResetPitchAfter());
        }

        private IEnumerator ResetPitchAfter()
        {
            while (!destroyCancellationToken.IsCancellationRequested)
            {
                yield return new WaitUntil(() => Time.time > _lastInputTime + recenterAfter);
                
            }
        }

        private void Update()
        {
            if (Input.GetKey(KeyCode.J))
            {
                ResetToOrigin();
            }
            var dir = InputManager.GetCameraYInput();
            if (dir != 0)
            {
                _lastInputTime = Time.time;
            }
            var vel = dir * movementSpeed * Time.deltaTime;
            if (vel == 0
                || vel > 0 && WillSurpassUpperBound()
                || vel < 0 && WillSurpassLowerBound())
            {
                return;
            }

            transform.Translate(0, vel, 0, Space.Self);

            bool WillSurpassUpperBound()
                => transform.localPosition.y >= upperBound;

            bool WillSurpassLowerBound()
                => transform.localPosition.y <= lowerBound;
        }

        private void ResetOriginToCurrentPosition()
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
