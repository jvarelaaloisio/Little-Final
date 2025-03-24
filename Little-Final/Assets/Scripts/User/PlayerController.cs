using System.Collections;
using Characters;
using Core.Acting;
using Core.Extensions;
using Core.Gameplay;
using Core.Helpers;
using Core.Providers;
using Core.References;
using FsmAsync;
using UnityEngine;
using User.States;

namespace User
{
    public class PlayerController : MonoBehaviour, ISetup<PhysicsCharacter>
    {
        [Header("Providers")]
        [SerializeField] private DataProvider<IInputReader> inputReaderProvider;
        
        [SerializeField] private float fallingGravityMultiplier = 2.5f;
        
        [Header("State IDs")]
        [SerializeField] private IdContainer idleId;
        [SerializeField] private IdContainer walkId;
        
        private PhysicsCharacter _character;
        private Vector2 _lastInput;
        private float _directionMagnitude;
        private Coroutine _enableCoroutine;
        
        private FiniteStateMachine<IIdentification> _stateMachine;
        public IActor Actor => _character.Actor;

        private void Start()
        {
            if (_character)
                Setup(_character);
        }

        private void RestoreGravity()
            => _character.RemoveContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));

        private void AddGravity()
            => _character?.TryAddContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));

        private void OnEnable()
        {
            _enableCoroutine = StartCoroutine(EnableCoroutine());
            return;

            IEnumerator EnableCoroutine()
            {
                IInputReader inputReader = null;
                yield return new WaitUntil(() => inputReaderProvider.TryGetValue(out inputReader));
                inputReader.OnMoveInput += HandleMoveInput;
                inputReader.OnJumpPressed += StartJump;
            }
        }

        private void OnDisable()
        {
            _enableCoroutine.TryStop(this);
            if (!inputReaderProvider.TryGetValue(out var inputReader))
                return;
            inputReader.OnMoveInput -= HandleMoveInput;
            inputReader.OnJumpPressed -= StartJump;
        }

        public void Setup(PhysicsCharacter data)
        {
            _character = data;
            _character.FallingController.OnStartFalling += AddGravity;
            _character.FallingController.OnStopFalling += RestoreGravity;
            SetupFsm(_character);
        }

        private async void SetupFsm(PhysicsCharacter character)
        {
            State idle = new Idle
            {
                Name = "idle",
                Character = character,
                InputReader = inputReaderProvider.Value,
            };
            State walk = new Walk
            {
                Name = "walk",
                Character = character,
                InputReader = inputReaderProvider.Value,
            };
            _stateMachine = FiniteStateMachine<IIdentification>.Build(name)
                                                               .ThatLogsTransitions(Debug.unityLogger)
                                                               .ThatTransitionsBetween(idleId.Get,idle, walk)
                                                               .ThatTransitionsBetween(walkId.Get, walk, idle)
                                                               .Done();
            await _stateMachine.Start(idle);
        }

        private void StartJump()
            => _character.AddForce(Vector3.up * 5.5f);

        private void HandleMoveInput(Vector2 input)
        {
            _lastInput = input;
            if(!_character)
                return;
            
            var cameraTransform = Camera.main.transform;
            var forward = cameraTransform.TransformDirection(Vector3.forward);
            forward.y = 0;
            var right = cameraTransform.TransformDirection(Vector3.right);
            Vector3 direction = input.x * right + input.y * forward;
            direction.y = 0;
            _directionMagnitude = direction.magnitude;

            _character.Movement.direction = direction;
            
            
            var floorNormal = Vector3.up;
            if (Physics.Raycast(transform.position,
                    -transform.up,
                    out var hit,
                    10,
                    ~LayerMask.GetMask("Interactable")))
            {
                floorNormal = hit.normal;
            }
            Vector3 directionProjectedOnFloor = Vector3.ProjectOnPlane(direction, floorNormal);
            
            _character.Movement.direction = directionProjectedOnFloor;
        }

        private void OnGUI()
        {
#if UNITY_EDITOR && ENABLE_UI
            Rect rect = new Rect(10, 100, 250, 50);
            GUI.Box(rect, Texture2D.grayTexture);
            GUILayout.BeginArea(rect);
            GUI.skin.label.fontSize = 15;
            GUI.skin.label.normal.textColor = Color.cyan;
            GUILayout.Label($"Move input : {_lastInput}");
            GUILayout.Label($"input magnitude : {_directionMagnitude}");
            GUILayout.Label($"Velocity   : {GetComponent<Rigidbody>().velocity}");
            GUILayout.EndArea();
#endif
        }
    }
}