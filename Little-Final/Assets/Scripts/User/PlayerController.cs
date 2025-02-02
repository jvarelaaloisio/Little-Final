using System.Collections;
using Characters;
using Core.Gameplay;
using Core.Providers;
using UnityEngine;

namespace User
{
    public class PlayerController : MonoBehaviour
    {
        [Header("Providers")]
        [SerializeField] private DataProvider<IInputReader> inputReaderProvider;
        
        [Header("Movement")]
        [SerializeField] private float acceleration = 20;
        [SerializeField] private float goalSpeed = 2;
        
        private PhysicsCharacter _character;
        private Vector2 _input;
        private float _directionMagnitude;
        [SerializeField] private float fallingGravityMultiplier = 2.5f;

        private void OnValidate()
        {
            if (!Application.isPlaying || !_character)
                return;
            _character.Movement.goalSpeed = goalSpeed;
            _character.Movement.acceleration = acceleration;
        }

        private void Start()
        {
            _character = gameObject.AddComponent<PhysicsCharacter>();
            _character.overrideLifeCycle = true;
            _character.Setup(new PhysicsCharacter.Data());
            _character.Movement.goalSpeed = goalSpeed;
            _character.Movement.acceleration = acceleration;
            _character.FallingController.OnStartFalling += AddGravity;
            _character.FallingController.OnStopFalling += RestoreGravity;
        }

        private void RestoreGravity()
        {
            _character.RemoveContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));
        }

        private void AddGravity()
        {
            _character?.TryAddContinuousForce(Physics.gravity * Mathf.Max(0, fallingGravityMultiplier - 1));
        }

        private void OnEnable()
        {
            StartCoroutine(EnableCoroutine());
            return;

            IEnumerator EnableCoroutine()
            {
                IInputReader inputReader = null;
                yield return new WaitUntil(() => inputReaderProvider.TryGetValue(out inputReader));
                inputReader.OnMoveInput += UpdateMovement;
                inputReader.OnJumpPressed += StartJump;
            }
        }

        private void OnDisable()
        {
            if (!inputReaderProvider.TryGetValue(out var inputReader))
                return;
            inputReader.OnMoveInput -= UpdateMovement;
            inputReader.OnJumpPressed -= StartJump;
        }

        private void StartJump()
        {
            _character.AddForce(Vector3.up * 5.5f);
        }

        private void UpdateMovement(Vector2 input)
        {
            _input = input;
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
            GUILayout.Label($"Move input : {_input}");
            GUILayout.Label($"input magnitude : {_directionMagnitude}");
            GUILayout.Label($"Velocity   : {GetComponent<Rigidbody>().velocity}");
            GUILayout.EndArea();
#endif
        }
    }
}