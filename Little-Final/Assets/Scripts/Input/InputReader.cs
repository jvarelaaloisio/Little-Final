using System;
using System.Collections;
using System.Linq;
using Core.Gameplay;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Input
{
    [RequireComponent(typeof(PlayerInput))]
    public class InputReader : MonoBehaviour, IInputReader
    {
        [Header("Setup")]
        [SerializeField] private string[] gamepadSchemes = { "Gamepad" };
        [Header("Actions")]
        [SerializeField] private string moveActionName = "Move";
        [SerializeField] private string cameraActionName = "Camera";
        
        private PlayerInput _playerInput;
        private Coroutine _gamepadCameraCoroutine;
        private PlayerInput playerInput => _playerInput ??= GetComponent<PlayerInput>();

        public event Action<Vector2> OnMoveInput = delegate { };
        public event Action<Vector2> OnCameraInput = delegate { };
        private void OnEnable()
        {
            var actions = playerInput.actions;
            playerInput.onControlsChanged += HandleControlChanged;
            actions.FindAction(moveActionName).performed += HandleMove;
        }

        private void HandleControlChanged(PlayerInput ctx)
        {
            var actions = ctx.actions;
            if (gamepadSchemes.Contains(ctx.currentControlScheme))
            {
                _gamepadCameraCoroutine ??= StartCoroutine(HandleGamepadCamera(actions.FindAction(cameraActionName)));
                actions.FindAction(cameraActionName).performed -= HandleCamera;
            }
            else
            {
                if (_gamepadCameraCoroutine != null)
                    StopCoroutine(_gamepadCameraCoroutine);
                actions.FindAction(cameraActionName).performed += HandleCamera;
            }
        }

        private IEnumerator HandleGamepadCamera(InputAction action)
        {
            yield return null;
            NotifyCamera(action.ReadValue<Vector2>());
        }

        private void HandleCamera(InputAction.CallbackContext ctx)
            => NotifyCamera(ctx.ReadValue<Vector2>());

        private void NotifyCamera(Vector2 value)
            => OnCameraInput(value);

        private void HandleMove(InputAction.CallbackContext ctx)
            => OnMoveInput(ctx.ReadValue<Vector2>());
    }
}
