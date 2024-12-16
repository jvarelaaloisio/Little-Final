using System;
using CharacterMovement;
using Core.Extensions;
using Core.Gameplay;
using UnityEngine;

namespace Player.States
{
    public class WalkWithInputReader : State
    {
        /// <inheritdoc />
        public override void OnStateEnter(PlayerController controller, IInputReader inputReader, int sceneIndex)
        {
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
        public override void OnStateUpdate() { }

        /// <inheritdoc />
        public override void OnStateExit() { }

        private void HandleMove(Vector2 input)
        {
            var desiredDirection = Camera.main.transform.TransformDirection(new Vector3(input.x, 0, input.y));

        }

        private void HandleJumpPressed()
        {
            throw new System.NotImplementedException();
        }

        private void HandleInteractPressed()
        {
            throw new System.NotImplementedException();
        }

        private void HandleClimbPressed()
        {
            throw new System.NotImplementedException();
        }
    }
}