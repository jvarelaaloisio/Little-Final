using System.Collections;
using CharacterMovement;
using Core.Extensions;
using Core.Gameplay;
using Core.Helpers.Movement;
using Core.Interactions;
using Player.Properties;
using UnityEngine;

namespace Player.States
{
    public class WalkWithInputReader : State
    {
        private IInputReader _inputReader;
        private Vector3 _currentDirection;
        private Coroutine _coyoteTime;

        /// <inheritdoc />
        public override void OnStateEnter(PlayerController controller, IInputReader inputReader, int sceneIndex)
        {
            _inputReader = inputReader;
            base.OnStateEnter(controller, inputReader, sceneIndex);

            if (this.IsNotNull(inputReader))
            {
                inputReader.OnMoveInput += HandleMove;
                inputReader.OnJumpPressed += HandleJumpPressed;
                inputReader.OnInteractPressed += HandleInteractPressed;
                inputReader.OnClimbPressed += HandleClimbPressed;
            }
        }

        /// <inheritdoc />
        public override void OnStateUpdate()
        {
            ValidateGround();
            Controller.RunAbilityList(Controller.AbilitiesOnLand);
        }

        /// <inheritdoc />
        public override void OnStateExit()
        {
            if (this.IsNotNull(_inputReader))
            {
                _inputReader.OnMoveInput += HandleMove;
                _inputReader.OnJumpPressed += HandleJumpPressed;
                _inputReader.OnInteractPressed += HandleInteractPressed;
                _inputReader.OnClimbPressed += HandleClimbPressed;
            }
        }
        
        protected virtual void ValidateGround()
        {
            if (!FallHelper.IsGrounded && _coyoteTime == null)
                Controller.StartCoroutine(CoyoteTimeCoroutine());
        }

        private IEnumerator CoyoteTimeCoroutine()
        {
            yield return new WaitForSeconds(PP_Jump.CoyoteTime);
            if (FallHelper.IsGrounded)
                yield break;
            Controller.ChangeState<Jump>();
            Controller.OnJump.Invoke();
        }

        private void HandleMove(Vector2 input)
        {
            _currentDirection = Camera.main.transform.TransformDirection(new Vector3(input.x, 0, input.y));

            var floorNormal = Body.LastFloorNormal;
            if (Physics.Raycast(MyTransform.position, -MyTransform.up, out var hit, 10,
                                ~LayerMask.GetMask("Interactable")))
            {
                floorNormal = hit.normal;
            }
            var directionProjectedOnFloor = Vector3.ProjectOnPlane(_currentDirection, floorNormal);
            Debug.DrawRay(MyTransform.position, directionProjectedOnFloor / 3, Color.grey);

            if (MoveHelper.IsSafeAngle(MyTransform.position, directionProjectedOnFloor.normalized, .3f,
                                       PP_Walk.MinSafeAngle))
            {
                MoveHelper.Rotate(MyTransform,
                                  _currentDirection,
                                  _currentDirection.magnitude * PP_Walk.TurnSpeed);
                MoveHelper.Move(MyTransform,
                                Body,
                                directionProjectedOnFloor,
                                PP_Walk.Speed * Controller.BuffMultiplier,
                                PP_Walk.Acceleration);
            }

            if (input.magnitude > 0
                && Controller.StepUp != null
                && Controller.StepUp.Should(directionProjectedOnFloor, PP_Walk.StepUpConfig)
                && Controller.StepUp.Can(out var stepPosition, MyTransform.forward, PP_Walk.StepUpConfig))
            {
                Controller.StepUp.StepUp(PP_Walk.StepUpConfig,
                                         stepPosition,
                                         () => Controller.ChangeState<WalkWithInputReader>());
                Controller.ChangeState<Void>();
            }

            float moveSpeed = Body.Velocity.IgnoreY().magnitude;
            Controller.OnChangeSpeed(moveSpeed);
        }

        private void HandleJumpPressed()
        {
            Jump(_currentDirection, false);
        }

        private void HandleInteractPressed()
        {
            if (Controller.HasItem())
                Controller.ChangeState(nameof(Throw));
            //TODO: Rework this
            else if (Controller.CanInteract(out var interactable))
            {
                switch (interactable)
                {
                    case IPickable pickable:
                        Controller.Pick(pickable);
                        break;
                    case IRideable rideable:
                        Controller.Rideable = rideable;
                        Controller.ChangeState<Mount>();
                        break;
                    default:
                        interactable.Interact(Controller);
                        break;
                }
            }
        }

        private void HandleClimbPressed()
        {
            if (Controller.ItemPicked == null)
                CheckClimb();
        }
        
        //TODO: This shouldn't be handled by this class
        protected void CheckClimb()
        {
            var climbCheckPosition = Controller.ClimbCheckPivot.position;
            if (Controller.Stamina.FillState > 0
                && ClimbHelper.CanClimb(climbCheckPosition,
                                        GetForwardDirectionBasedOnGroundAngle(),
                                        PP_Climb.MaxDistanceToTriggerClimb,
                                        PP_Climb.MaxClimbAngle,
                                        out var climbHit))
            {
                Controller.LastClimbHit = climbHit;
                Controller.ChangeState<Climb>();
            }

            Vector3 GetForwardDirectionBasedOnGroundAngle()
            {
                if (!Physics.Raycast(climbCheckPosition, -MyTransform.up, out var hit,
                                     PP_Climb.MaxClimbDistanceFromCorners,
                                     LayerMask.GetMask("Floor", "Default")))
                    return MyTransform.forward;
                var newForward = Vector3.Cross(MyTransform.right, hit.normal);
                return newForward;
            }
        }
    }
}