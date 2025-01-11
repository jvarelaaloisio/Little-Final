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
        [SerializeField] private InputActionReference moveInput;
        [SerializeField] private InputActionReference cameraInput;
        [SerializeField] private InputActionReference centerCameraInput;
        [SerializeField] private InputActionReference jumpInput;
        [SerializeField] private InputActionReference glideInput;
        [SerializeField] private InputActionReference climbInput;
        [SerializeField] private InputActionReference interactInput;
        [SerializeField] private InputActionReference abilityInput;
        [SerializeField] private InputActionReference pauseInput;
        
        private PlayerInput _playerInput;
        private Coroutine _gamepadCameraCoroutine;
        private PlayerInput playerInput => _playerInput ??= GetComponent<PlayerInput>();

        public event Action<Vector2> OnMoveInput = delegate { };
        public event Action<Vector2> OnCameraInput = delegate { };
        public event Action OnCenterCameraPressed = delegate { };
        public event Action OnJumpPressed = delegate { };
        public event Action OnJumpReleased = delegate { };
        public event Action OnGlidePressed = delegate { };
        public event Action OnGlideReleased = delegate { };
        public event Action OnClimbPressed = delegate { };
        public event Action OnClimbReleased = delegate { };
        public event Action OnInteractPressed = delegate { };
        public event Action OnInteractReleased = delegate { };
        public event Action OnAbilityPressed = delegate { };
        public event Action OnAbilityReleased = delegate { };
        public event Action OnPause = delegate { };

        private void OnEnable()
        {
            playerInput.onControlsChanged += HandleControlChanged;
            if (moveInput?.action is { } moveAction)
                moveAction.performed += HandleMove;
            if (cameraInput?.action is { } cameraAction)
            {
                cameraAction.performed += HandleCamera;
                cameraAction.canceled += HandleCamera;
            }
            if (centerCameraInput?.action is { } centerCameraAction)
            {
                centerCameraAction.started += _ => OnCenterCameraPressed();
            }
            if (jumpInput?.action is { } jumpAction)
            {
                jumpAction.started += _ => OnJumpPressed();
                jumpAction.canceled += _ => OnJumpReleased();
            }
            if (glideInput?.action is { } glideAction)
            {
                glideAction.started += _ => OnGlidePressed();
                glideAction.canceled += _ => OnGlideReleased();
            }
            if (climbInput?.action is { } climbAction)
            {
                climbAction.started += _ => OnClimbPressed();
                climbAction.canceled += _ => OnClimbReleased();
            }
            if (interactInput?.action is { } interactAction)
            {
                interactAction.started += _ => OnInteractPressed();
                interactAction.canceled += _ => OnInteractReleased();
            }
            if (abilityInput?.action is { } abilityAction)
            {
                abilityAction.started += _ => OnAbilityPressed();
                abilityAction.canceled += _ => OnAbilityReleased();
            }
            if (pauseInput?.action is { } pauseAction)
                pauseAction.performed += _ => OnPause();
        }

        private void HandleControlChanged(PlayerInput ctx)
        {
            if (!cameraInput)
            {
                Debug.LogError($"{name}: {nameof(cameraInput)} is null!");
                return;
            }

            var cameraAction = cameraInput.action;
            var isGamepad = gamepadSchemes.Contains(ctx.currentControlScheme);
            if (isGamepad)
            {
                _gamepadCameraCoroutine ??= StartCoroutine(HandleGamepadCamera(cameraAction));
                cameraAction.performed -= HandleCamera;
            }
            else
            {
                if (_gamepadCameraCoroutine != null)
                    StopCoroutine(_gamepadCameraCoroutine);
                cameraAction.performed -= HandleCamera;
                cameraAction.performed += HandleCamera;
            }
        }

        private IEnumerator HandleGamepadCamera(InputAction action)
        {
            yield return null;
            NotifyCamera(action.ReadValue<Vector2>() * Time.deltaTime);
        }

        private void HandleCamera(InputAction.CallbackContext ctx)
            => NotifyCamera(ctx.ReadValue<Vector2>());

        private void NotifyCamera(Vector2 value)
            => OnCameraInput(value);

        private void HandleMove(InputAction.CallbackContext ctx)
            => OnMoveInput(ctx.ReadValue<Vector2>());
    }
}
