using System;
using Core.Debugging;
using Core.Interactions;
using Player.PlayerInput;
using UnityEngine;

namespace Player.States
{
    public class Throw : State
    {
        private readonly ThrowConfig _config;
        private readonly Debugger _debugger;
        private float _beggining = 0;
        public event Action<float> OnThrowPercentageUpdate = delegate { };
        public event Action OnThrowing = delegate { };
        public event Action OnThrew = delegate { };
        public Throw(ThrowConfig config, Debugger debugger)
        {
            _config = config;
            _debugger = debugger;
        }

        public override void OnStateEnter(PlayerController controller, int sceneIndex)
        {
            base.OnStateEnter(controller, sceneIndex);
            _beggining = Time.time;
            OnThrowPercentageUpdate(0);
            controller.Body.RequestMovement(MovementRequest.InvalidRequest);
            controller.onPutDown.AddListener(HandlePutDown);
            OnThrowing();
        }

        public override void OnStateUpdate()
        {
            if (!InputManager.IsHoldingInteract())
            {
                Controller.PutDownItem();
                Controller.ChangeState<Walk>();
                return;
            }

            var now = Time.time;
            OnThrowPercentageUpdate((now - _beggining) / _config.Duration);
            
            if (_beggining + _config.Duration <= now)
            {
                _debugger.LogSafely(Controller.name, $"Throwing Item", Controller);
                OnThrowPercentageUpdate(1);
                Controller.onPutDown.RemoveListener(HandlePutDown);
                Controller.ThrowItem(_config.Force);
                Controller.ChangeState<Walk>();
            }
        }

        public override void OnStateExit()
        {
            OnThrowPercentageUpdate(0);
        }

        private void HandlePutDown()
        {
            Controller.ChangeState<Walk>();
        }
    }
}