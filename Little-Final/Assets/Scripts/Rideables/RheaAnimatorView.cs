using System;
using System.Collections.Generic;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Rideables
{
    public class RheaAnimatorView : MonoBehaviour, ILateUpdateable
    {
        [SerializeField]
        private Rigidbody rigidbody;

        [SerializeField]
        private Animator animator;

        private void OnValidate()
        {
            if(!animator) TryGetComponent(out animator);
            if(!rigidbody) TryGetComponent(out rigidbody);
        }

        private void Awake()
        {
            if (!rigidbody) Debug.LogError("Rigidbody field not set", this);
            if (!animator) Debug.LogError("Animator field not set", this);
        }

        private void Start()
        {
            UpdateManager.Subscribe(this);
        }

        public void OnLateUpdate()
        {
            // animator.SetBool();
        }
    }
}