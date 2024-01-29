using System.Collections;
using Core;
using HealthSystem.Runtime.Components;
using Interactions.Pickable;
using UnityEngine;
using UnityEngine.Events;

namespace Logic.Code.Others
{
    [RequireComponent(typeof(PickableItem))]
    [RequireComponent(typeof(HealthComponent))]
    [RequireComponent(typeof(Rigidbody))]
    [DisallowMultipleComponent]
    public class PickableRevive : MonoBehaviour
    {
        [SerializeField] private float reviveCooldown = 2f;
        
        [Header("Setup")]
        [SerializeField] private PickableItem pickableItem;

        [SerializeField] private HealthComponent healthComponent;

        [SerializeField] private new Rigidbody rigidbody;

        [SerializeField] private UnityEvent onDeath;

        private TransformData _origin;

        private void Reset()
        {
            pickableItem = GetComponent<PickableItem>();
            rigidbody = GetComponent<Rigidbody>();
            healthComponent = GetComponent<HealthComponent>();
        }
        
        private void OnValidate()
        {
            pickableItem ??= GetComponent<PickableItem>();
            rigidbody ??= GetComponent<Rigidbody>();
            healthComponent ??= GetComponent<HealthComponent>();
        }

        private void Awake()
        {
            _origin = new TransformData(transform);
        }

        private void OnEnable()
        {
            healthComponent.Health.OnDeath += HandleDeath;
        }

        private void OnDisable()
        {
            healthComponent.Health.OnDeath -= HandleDeath;
        }

        private void HandleDeath()
        {
            onDeath.Invoke();
            StartCoroutine(ReviveIn(reviveCooldown));
        }

        private IEnumerator ReviveIn(float delay)
        {
            yield return new WaitForSeconds(delay);
            _origin.ApplyDataTo(transform);
            healthComponent.Health.FullyHeal();
            rigidbody.velocity = Vector3.zero;
        }
    }
}