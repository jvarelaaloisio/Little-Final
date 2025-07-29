using System.Collections.Generic;
using Core.Attributes;
using Core.Data;
using Core.Extensions;
using Player;
using UnityEngine;

namespace Characters
{
    [RequireComponent(typeof(Rigidbody))]
    public class PhysicsCharacter : Character<ReverseIndexStore>, IPhysicsCharacter<ReverseIndexStore>
    {
        [SerializeField] private AnimationCurve movementCurve = AnimationCurve.EaseInOut(0, 1, 1, 0);
        [SerializeField] private bool enableLog = false;
        private Rigidbody _rigidbody;
        public Rigidbody rigidbody => _rigidbody ??= GetComponent<Rigidbody>();

        private readonly HashSet<ForceRequest> _forceRequests = new ();
        private readonly HashSet<ForceRequest> _continuousForceRequests = new ();
        private FallingController _fallingController;

        public override IFallingController FallingController => _fallingController;

        public override Vector3 Velocity
        {
            get => rigidbody.velocity;
            set => rigidbody.velocity = value;
        }

        /// <inheritdoc />
        protected override void Awake()
        {
            base.Awake();
            _fallingController = new FallingController(rigidbody, FloorTracker);
        }

        private void Update()
            => _fallingController?.Update();

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
        public override void Jump(float force)
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
        {
            var forceRequest = new ForceRequest(force, mode);
            var success = _continuousForceRequests.Add(forceRequest);
            if (success && enableLog)
                this.Log($"Added force ({force})({mode})");
            return success;
        }

        /// <summary>
        /// Removes a requests from the continuous forces List
        /// </summary>
        /// <param name="force"></param>
        /// <param name="mode"></param>
        public void RemoveContinuousForce(Vector3 force, ForceMode mode = ForceMode.Force)
        {
            var forceRequest = new ForceRequest(force, mode);
            if (_continuousForceRequests.Remove(forceRequest)
                && enableLog)
                this.Log($"Removed force ({force})({mode})");
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
            var currentVelocity = rigidbody.velocity;
            var x = Mathf.Sqrt(currentVelocity.x * currentVelocity.x + currentVelocity.z * currentVelocity.z);
            var force = movementCurve.Evaluate(x / Movement.goalSpeed) * Movement.acceleration;
            rigidbody.AddForce(Movement.direction * force, ForceMode.Force);
        }
    }
}