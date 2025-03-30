using System;
using System.Collections;
using Characters;
using Core.Acting;
using Core.Extensions;
using Core.Gameplay;
using Core.Helpers;
using Core.Providers;
using Core.References;
using Cysharp.Threading.Tasks;
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
        
        [Header("States")]
        [SerializeField] private Idle idle = new() {Name = "Idle"};
        [SerializeField] private Walk walk = new() {Name = "Walk"};
        
        [Header("Ids")]
        [SerializeField] private IdContainer stopId;
        [SerializeField] private IdContainer moveId;
        [SerializeField] private IdContainer lastInputId;
        
        private PhysicsCharacter _character;
        private Vector2 _lastInput;
        private float _directionMagnitude;
        private Coroutine _enableCoroutine;
        
        private FiniteStateMachine<IIdentification> _stateMachine;
        private Texture2D _blackTexture;

        public Texture2D BlackTexture => _blackTexture ??= new Texture2D(1, 1);

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
            _stateMachine.Current.Sleep(new Hashtable(), destroyCancellationToken);
        }

        public void Setup(PhysicsCharacter data)
        {
            _character = data;
            _character.FallingController.OnStartFalling += AddGravity;
            _character.FallingController.OnStopFalling += RestoreGravity;
            SetupFsm(_character);
        }

        private void Update()
        {
            Debug.DrawRay(transform.position + Vector3.up, walk._directionProjectedOnFloor / 3, Color.cyan);
        }

        private async void SetupFsm(PhysicsCharacter character)
        {
            //THOUGHT: These states should be loaded from a file in the future. And that file should be created from the FSM Editor
            idle.Character = character;
            idle.InputReader = inputReaderProvider?.Value;
            idle.Logger = Debug.unityLogger;
            
            walk.Character = character;
            walk.InputReader = inputReaderProvider?.Value;
            walk.Logger = Debug.unityLogger;
            
            //TODO:Add jump
            _stateMachine = FiniteStateMachine<IIdentification>.Build(name)
                                                               .ThatLogsTransitions(Debug.unityLogger)
                                                               .ThatTransitionsBetween(stopId.Get, walk, idle)
                                                               .ThatTransitionsBetween(moveId.Get,idle, walk)
                                                               .Done();
            await _stateMachine.Start(idle, destroyCancellationToken);
        }

        private void StartJump()
            => _character.AddForce(Vector3.up * 5.5f);

        private async void HandleMoveInput(Vector2 input)
        {
            _lastInput = input;
            _directionMagnitude = input.magnitude;
            if(!_character)
                return;
            var stateId = input.magnitude > 0.001f ? moveId : stopId;
            var data = new Hashtable();
            if (lastInputId)
            {
                data.Add(lastInputId.Get, input);
            }
            await _stateMachine.TryTransitionTo(stateId.Get, destroyCancellationToken, data);
        }

        private void OnGUI()
        {
#if UNITY_EDITOR && ENABLE_UI
            Rect rect = new Rect(10, 50, 300, 150);
            Color textureColor = new Color(0, 0, 0, .75f);

            BlackTexture.SetPixel(0, 0, textureColor);
            BlackTexture.Apply();
            GUI.Box(rect, BlackTexture, GUIStyle.none);
            GUI.DrawTexture(rect, BlackTexture);
            GUILayout.BeginArea(rect);
            GUI.skin.label.fontSize = 15;
            GUI.skin.label.normal.textColor = Color.cyan;
            GUILayout.Label($"State : {_stateMachine?.Current?.Name}");
            //GUILayout.Label($"Move input : {_lastInput}");
            var speed = _character?.Velocity.IgnoreY().magnitude;
            var goalSpeed = _character?.Movement?.goalSpeed;
            GUILayout.Label($"{1.0f * speed / goalSpeed:f2}");
            //GUILayout.Label($"Velocity   : {GetComponent<Rigidbody>().velocity}");
            GUILayout.EndArea();
#endif
        }
    }
}