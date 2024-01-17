using System;
using System.Collections;
using HealthSystem.Runtime;
using UnityEngine;

namespace Samples.KillBound.Scripts.SampleSpecificLogic
{
    [RequireComponent(typeof(Rigidbody))]
    public class SimpleCharacter : MonoBehaviour
    {
        [Range(0.1f, 10)] [SerializeField] private float speed = 3;
        [SerializeField] private float jumpForce;

        private Rigidbody _rigidbody;
        private Vector3 _moveInput = Vector3.zero;
        private bool _jumpRequest = false;
        private Vector3 _origin;
        private IHealthComponent _healthComponent;

        private void Awake()
        {
            _rigidbody = GetComponent<Rigidbody>();
            _origin = transform.position;
        }

        private void OnEnable()
        {
            if (TryGetComponent(out _healthComponent))
                StartCoroutine(SubscribeToRevive());
        }

        private IEnumerator SubscribeToRevive()
        {
            while (!destroyCancellationToken.IsCancellationRequested && _healthComponent.Health == null)
            {
                yield return null;
            }
            _healthComponent.Health.OnDeath += Revive;
        }

        private void OnDisable()
        {
            if (_healthComponent is { Health: not null })
            {
                _healthComponent.Health.OnDeath -= Revive;
            }
        }

        private void Update()
        {
            _moveInput = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            if (Input.GetButtonDown("Jump"))
            {
                _jumpRequest = true;
            }
        }

        private void FixedUpdate()
        {
            _rigidbody.MovePosition(_rigidbody.position + _moveInput * (speed * Time.fixedDeltaTime));
            if (_jumpRequest)
            {
                _rigidbody.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
                _jumpRequest = false;
            }
        }

        private void Revive()
        {
            _rigidbody.MovePosition(_origin);
            _healthComponent.Health.FullyHeal();
        }
    }
}