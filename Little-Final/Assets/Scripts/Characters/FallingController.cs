using System;
using UnityEngine;

namespace Characters
{
    public class FallingController
    {
        private readonly Rigidbody _rigidbody;

        public FallingController(Rigidbody rigidbody)
            => _rigidbody = rigidbody;

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
            switch (IsFalling)
            {
                case true when _rigidbody.velocity.y > -0.1f:
                    IsFalling = false;
                    OnStopFalling();
                    break;
                case false when _rigidbody.velocity.y < -0.1f:
                    IsFalling = true;
                    OnStartFalling();
                    break;
            }
        }
    }
}