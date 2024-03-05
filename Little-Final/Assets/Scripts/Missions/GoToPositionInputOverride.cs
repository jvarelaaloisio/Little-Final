using CharacterMovement;
using Core.Extensions;
using Core.Providers;
using Player.PlayerInput;
using UnityEngine;

namespace Sequences
{
    public class GoToPositionInputOverride : MonoBehaviour, IPlayerInput
    {
        [SerializeField] private DataProvider<Transform> playerProvider;
        private Vector3 _destination;
        private float _acceptableDistance;
        private IPlayerInput _lastInput;
        public bool HasArrived { get; private set; } = false;

        public void Replace(Vector3 destination, float acceptableDistance)
        {
            _destination = destination;
            _acceptableDistance = acceptableDistance;
            HasArrived = false;
            _lastInput = InputManager.InputReader;
            InputManager.InputReader = this;
        }

        public void SetDestination(Vector3 destination)
        {
            _destination = destination;
            HasArrived = false;
        }

        public void StopReplacing()
        {
            if (_lastInput != null)
            {
                InputManager.InputReader = _lastInput;
            }
        }
        public Vector2 GetHorInput()
        {
            Vector3 positionToPlayer = Vector3.zero;
            if (playerProvider.TryGetValue(out var player))
            {
                positionToPlayer = (_destination - player.position).IgnoreY();
                if (positionToPlayer.magnitude > _acceptableDistance)
                {
                    Debug.DrawRay(player.position, positionToPlayer, Color.blue);
                    return MoveHelper.GetInput(positionToPlayer.IgnoreY().normalized);
                }

                HasArrived = true;
                return Vector2.zero;
            }
            this.LogError($"{nameof(playerProvider)}'s value is null");
            return Vector2.zero;
        }

        public bool GetClimbInput() => false;

        public bool GetJumpInput() => false;

        public bool GetLongJumpInput() => false;

        public bool GetGlideInput() => false;

        public bool GetRunInput() => false;

        public bool GetSwirlInput() => false;

        public bool GetPickInput() => false;

        public bool IsHoldingInteract() => false;

        public bool GetInteractInput() => false;

        public bool GetCameraResetInput() => false;

        public float GetCameraYInput() => 0;
    }
}