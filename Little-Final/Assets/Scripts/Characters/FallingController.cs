using System;
using System.Collections.Generic;
using System.Linq;
using Interactions.EventTriggers;
using UnityEngine;

namespace Characters
{
    public class FallingController : IFallingController
    {
        private readonly Rigidbody _rigidbody;
        private readonly IFloorTracker _floorTracker;

        public FallingController(Rigidbody rigidbody, IFloorTracker floorTracker)
        {
            _rigidbody = rigidbody;
            _floorTracker = floorTracker;
        }

        /// <summary>
        /// Event risen when <see cref="_rigidbody"/>.<see cref="Rigidbody.velocity"/>.y becomes less than 0
        /// </summary>
        public event Action OnStartFalling = delegate { };

        /// <summary>
        /// Event risen when <see cref="Velocity"/>.y becomes less than 0
        /// </summary>
        public event Action OnStopFalling = delegate { };

        public bool IsFalling { get; private set; }

        /// <summary>
        /// Call this method to check if any events should be risen
        /// </summary>
        public void Update()
        {
            ValidateIfFallingStateHasChanged();
            return;

            void ValidateIfFallingStateHasChanged()
            {
                if (IsFalling && _rigidbody.velocity.y > -0.1f && _floorTracker.CurrentFloorData.distance < 0.21f)
                {
                    IsFalling = false;
                    OnStopFalling();
                }
                else if (!IsFalling && _rigidbody.velocity.y < -0.1f && _floorTracker.CurrentFloorData.distance >= 0.21f)
                {
                    IsFalling = true;
                    OnStartFalling();
                }
            }
        }
    }
}