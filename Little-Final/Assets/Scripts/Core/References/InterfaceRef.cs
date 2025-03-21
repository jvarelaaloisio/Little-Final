using System;
using UnityEngine;

namespace Core.References
{
    [Serializable]
    public struct InterfaceRef<T> : ISerializationCallbackReceiver
    {
        [SerializeField] private UnityEngine.Object reference;
        private UnityEngine.Object _oldReference;
        public T Ref
        {
            get => reference != null ? (T)(object)reference : default;
            set
            {
                reference = value as UnityEngine.Object;
                Validate();
            }
        }

        public void OnBeforeSerialize()
            => Validate();

        public void OnAfterDeserialize() { }

        private void Validate()
        {
            if (reference is GameObject gameObject
                && gameObject.TryGetComponent(out T target))
                reference = target as UnityEngine.Object;

            if (reference != null && reference is not T)
            {
                Debug.LogError($"{reference.GetType().Name} does not implement {typeof(T)}");
                reference = _oldReference;
            }
            else
            {
                _oldReference = reference;
            }
        }
    }
}