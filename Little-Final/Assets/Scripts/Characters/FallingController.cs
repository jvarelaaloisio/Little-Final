using System;
using System.Collections.Generic;
using System.Linq;
using Core.Attributes;
using Core.References;
using Interactions.EventTriggers;
using UnityEngine;

namespace Characters
{
    [Serializable]
    public class FallingController : IFallingController, ISetup<Rigidbody, IFloorTracker>
    {
        [NonSerialized] private Rigidbody _rigidbody;
        [NonSerialized] private IFloorTracker _floorTracker;
        [SerializeField] private float landingDistanceToFloor = 0.21f;
        [SerializeField] private float minYSpeedForFalling = -0.1f;

        public void Setup(Rigidbody body, IFloorTracker floorTracker)
        {
            _rigidbody = body;
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

        [field:SerializeField][field:SerializeReadOnly]public bool IsFalling { get; private set; }

        /// <summary>
        /// Call this method to check if any events should be risen
        /// </summary>
        public void Update()
        {
            ValidateIfFallingStateHasChanged();
            return;

            void ValidateIfFallingStateHasChanged()
            {
                if (IsFalling && _rigidbody.velocity.y > minYSpeedForFalling && _floorTracker.CurrentFloorData.distance < landingDistanceToFloor)
                {
                    IsFalling = false;
                    OnStopFalling();
                }
                else if (!IsFalling && _rigidbody.velocity.y < minYSpeedForFalling && _floorTracker.CurrentFloorData.distance >= landingDistanceToFloor)
                {
                    IsFalling = true;
                    OnStartFalling();
                }
            }
        }
    }
}