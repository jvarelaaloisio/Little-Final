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
using DataProviders.Async;
using FsmAsync;
using UnityEngine;
using User.States;

namespace User
{
    public class PlayerController : MonoBehaviour, ISetup<PhysicsCharacter>
    {
        [Header("Providers")]
        [SerializeField] private InterfaceRef<IDataProviderAsync<IInputReader>> inputReaderProvider;
        
        [SerializeField] private float fallingGravityMultiplier = 2.5f;
        
        [Header("States")]
        [SerializeField] private InterfaceRef<ICharacterState> idle;
        [SerializeField] private InterfaceRef<ICharacterState> walk;
        [SerializeField] private InterfaceRef<ICharacterState> jump;
        [SerializeField] private InterfaceRef<ICharacterState> fall;
        [SerializeField] private InterfaceRef<ICharacterState> walkWhileFalling;
        
        [Header("Ids")]
        [SerializeField] private IdContainer stopId;
        [SerializeField] private IdContainer moveId;
        [SerializeField] private IdContainer jumpId;
        [SerializeField] private IdContainer landId;
        [SerializeField] private IdContainer lastInputId;
        
        private PhysicsCharacter _character;
        private Vector2 _lastInput;
        private float _directionMagnitude;
        private Coroutine _enableCoroutine;
        
        private FiniteStateMachine<IIdentification> _stateMachine;
        private AutoMap<Texture2D> BlackTexture = new(() => new Texture2D(1, 1));
        
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

        private async void OnEnable()
        {
            if (inputReaderProvider.Ref == null)
            {
                Debug.LogError($"{name} <color=grey>({nameof(PlayerController)})</color>: {nameof(inputReaderProvider)} is null!");
                return;
            }
            var inputReader = await inputReaderProvider.Ref.GetValueAsync(destroyCancellationToken);
            inputReader.OnMoveInput += HandleMoveInput;
            inputReader.OnJumpPressed += StartJump;
        }

        private void OnDisable()
        {
            _enableCoroutine.TryStop(this);
            if (inputReaderProvider.Ref.TryGetValue(out var inputReader))
            {
                inputReader.OnMoveInput -= HandleMoveInput;
                inputReader.OnJumpPressed -= StartJump;
            }
            _stateMachine.Current.Exit(new Hashtable(), destroyCancellationToken).Forget();
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
            //THOUGHT: These states should be loaded from a file in the future. And that file should be created from the FSM Editor
            if (!character.TryGetComponent(out IFloorTracker floorTracker))
            {
                Debug.LogError($"{name}: {nameof(floorTracker)} component was not found in character!");
                return;
            }
            idle.Ref.Character = character;
            idle.Ref.Logger = Debug.unityLogger;
            
            walk.Ref.Character = character;
            walk.Ref.Logger = Debug.unityLogger;
            
            walkWhileFalling.Ref.Character = character;
            walkWhileFalling.Ref.Logger = Debug.unityLogger;
            
            jump.Ref.Character = character;
            jump.Ref.Logger = Debug.unityLogger;
            
            _stateMachine = FiniteStateMachine<IIdentification>.Build(name)
                                                               .ThatLogsTransitions(Debug.unityLogger)
                                                               
                                                               .ThatTransitionsBetween(stopId.Get, walk.Ref, idle.Ref)
                                                               .ThatTransitionsBetween(landId.Get, fall.Ref, idle.Ref)
                                                               
                                                               .ThatTransitionsBetween(moveId.Get, idle.Ref, walk.Ref)
                                                               .ThatTransitionsBetween(moveId.Get, fall.Ref, walkWhileFalling.Ref)
                                                               .ThatTransitionsBetween(moveId.Get, jump.Ref, walkWhileFalling.Ref)
                                                               
                                                               .ThatTransitionsBetween(jumpId.Get, idle.Ref, jump.Ref)
                                                               .ThatTransitionsBetween(jumpId.Get, walk.Ref, jump.Ref)
                                                               
                                                               .ThatTransitionsBetween(stopId.Get, walkWhileFalling.Ref, fall.Ref)
                                                               .ThatTransitionsBetween(stopId.Get, jump.Ref, fall.Ref)
                                                               .Done();
            await _stateMachine.Start(idle.Ref, destroyCancellationToken);
        }

        private void StartJump()
            => _character.AddForce(Vector3.up * 5.5f);

        private async void HandleMoveInput(Vector2 input)
        {
            _lastInput = input;
            _directionMagnitude = input.magnitude;
            if(!_character)
                return;
            //THOUGHT: Should there be a Condition SO that receives an Input and returns an ID so this logic is done by that structure?
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

            BlackTexture.Value.SetPixel(0, 0, textureColor);
            BlackTexture.Value.Apply();
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