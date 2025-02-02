using System;
using System.Collections.Generic;
using Core.Attributes;
using Core.Extensions;
using Player;
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
    [RequireComponent(typeof(Rigidbody))]
    public class PhysicsCharacter : Character<PhysicsCharacter.Data>
    {
        public class Data { }
        
        private Rigidbody _rigidbody;
        public Rigidbody rigidbody => _rigidbody ??= GetComponent<Rigidbody>();

        private readonly HashSet<ForceRequest> _forceRequests = new ();
        private readonly HashSet<ForceRequest> _continuousForceRequests = new ();
        [field: SerializeReadOnly] public MovementData Movement { get; private set; } = MovementData.InvalidRequest;
        public FallingController FallingController { get; private set; }

        public Vector3 Velocity
        {
            get => rigidbody.velocity;
            set => rigidbody.velocity = value;
        }

        protected override void Awake()
        {
            base.Awake();
            FallingController = new FallingController(rigidbody);
        }

        private void Update()
            => FallingController.Update();

        private void FixedUpdate()
        {
            ProcessForceRequests(in _forceRequests);
            ProcessForceRequests(in _continuousForceRequests, false);
            ProcessMovement();
        }

        /// <summary>
        /// Adds a force using this character's up vector , using <see cref="AddForce"/>.
        /// <remarks>Jump validations are not managed by this class, so infinite jumping is possible through this method.</remarks>
        /// <remarks>Validations for simple, double and multiple jumps must be done by the controlling class.</remarks>
        /// </summary>
        /// <param name="force">This value will be multiplied with <see cref="Transform"/>.<see cref="Transform.up"/></param>
        public void Jump(float force)
            => AddForce(transform.up * force);

        /// <summary>
        /// Adds a force to the list of forces that will be applied in the next fixedUpdate.
        /// <remarks>This is meant for instant forces mainly. If what you're looking for is to add a constant force, <i>like pushing with a stream of wind</i>, <see cref="TryAddContinuousForce"/> is recommended instead.</remarks>
        /// </summary>
        /// <param name="force" />
        /// <param name="forceMode">Default: <see cref="ForceMode"/>.<see cref="ForceMode.Impulse"/></param>
        public void AddForce(Vector3 force, ForceMode forceMode = ForceMode.Impulse)
        {
            _forceRequests.Add(new ForceRequest(force, forceMode));
        }

        /// <summary>
        /// Adds a request to the continuous forces List
        /// </summary>
        /// <param name="force">The force to be applied every fixed update</param>
        /// <param name="mode"></param>
        public bool TryAddContinuousForce(Vector3 force, ForceMode mode = ForceMode.Force)
            => _continuousForceRequests.Add(new ForceRequest(force, mode));

        /// <summary>
        /// Removes a requests from the continuous forces List
        /// </summary>
        /// <param name="request"></param>
        public void RemoveContinuousForce(Vector3 force, ForceMode mode = ForceMode.Force)
        {
            _continuousForceRequests.Remove(new ForceRequest(force, mode));
        }

        /// <summary>
        /// applies all given forces to the <see cref="rigidbody"/>
        /// </summary>
        /// <param name="requests">The forces to apply</param>
        /// <param name="shouldClearRequests">If <see cref="_forceRequests"/> should be cleared once the forces have been applied.</param>
        private void ProcessForceRequests(in HashSet<ForceRequest> requests, bool shouldClearRequests = true)
        {
            foreach (var request in requests)
                rigidbody.AddForce(request.Force, request.Mode);
            if (shouldClearRequests)
                requests.Clear();
        }

        private void ProcessMovement()
        {
            if(!Movement.IsValid())
                return;
            if (Velocity.IgnoreY().magnitude > Movement.goalSpeed)
            {
                return;
            }
            var acceleration = Movement.direction * Movement.acceleration;
            
            rigidbody.AddForce(acceleration, ForceMode.Force);
        }
    }
}