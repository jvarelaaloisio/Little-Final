using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

namespace Environment.ParticleSystemHelper
{
    [RequireComponent(typeof(BoxCollider))]
    public class ParticleSystemDynamicArea : MonoBehaviour
    {
        [Header("Settings"), SerializeField] private ParticleSystem particle;
        [SerializeField] private bool stopOnExit;
        [SerializeField] private bool updatePosition;
     
        [Header("Events"), SerializeField] private UnityEvent onEnterArea;
        [SerializeField] private UnityEvent onExitArea;
        
        [Header("Gizmo settings") ,SerializeField] private bool showGizmo = true;
        [SerializeField] private Color gizmoColor = new Color(0, 0, 1, .2f);

        private Transform _invokerTransform;
        private BoxCollider _collider;

        private void OnValidate()
        {
            LoadRequiredComponents();
        }
        
        private void Start()
        {
            LoadRequiredComponents();
            
            _collider.isTrigger = true;
        }

        private void Update()
        {
            if (updatePosition)
                particle.transform.position = _invokerTransform.position;
        }

        private void OnTriggerEnter(Collider other)
        {
            if (updatePosition)
                _invokerTransform = other.transform;
            
            PlayParticleSystem();
            onEnterArea?.Invoke();
        }

        private void OnTriggerExit(Collider other)
        {
            if (updatePosition)
                _invokerTransform = null;
            
            if(stopOnExit)
                particle.Stop();
            
            onExitArea?.Invoke();
        }
        
        private void PlayParticleSystem()
        {
            particle.Simulate(0.0f, true, true);
            particle.Play();
        }
        
        private void LoadRequiredComponents()
        {
            if(_collider == null)
                _collider = GetComponent<BoxCollider>();
        }

        private void OnDrawGizmos()
        {
            if (_collider != null)
            {
                var oldMatrix = Gizmos.matrix;
                
                Gizmos.matrix = transform.localToWorldMatrix;
                
                Gizmos.color = gizmoColor;
                Gizmos.DrawCube(_collider.center, _collider.size);
                
                Gizmos.color = new Color(1,1,1,.2f);
                Gizmos.DrawWireCube(_collider.center, _collider.size);

                Gizmos.matrix = oldMatrix;
            }
        }
    }
}