using System;
using UnityEngine;

namespace Core.References
{
    [Serializable]
    public struct InterfaceRef<T> : ISerializationCallbackReceiver
    {
        [SerializeField] private UnityEngine.Object reference;
        private UnityEngine.Object _oldReference;

        /// <summary>
        /// true if there is a reference assigned.
        /// </summary>
        public bool HasValue => reference;
        
        /// <summary>
        /// The Reference
        /// </summary>
        public T Ref
        {
            get => HasValue ? (T)(object)reference : default;
            set
            {
                reference = value as UnityEngine.Object;
                Validate();
            }
        }

        /// <summary>
        /// Called on EditorApplication.update, used before serializing the object from memory to text.
        /// </summary>
        public void OnBeforeSerialize()
        {
            if (_oldReference != reference)
                Validate();
        }

        /// <summary>
        /// Called when unity loads the object and deserializes it.
        /// </summary>
        public void OnAfterDeserialize()
            => _oldReference = reference;

        private void Validate()
        {
            if (reference is GameObject gameObject
                && gameObject.TryGetComponent(out T target))
                reference = target as UnityEngine.Object;

            if (reference && reference is not T)
            {
                Debug.LogError($"{reference.GetType().Name} does not implement {typeof(T)}");
                reference = _oldReference;
            }
            else
            {
                _oldReference = reference;
            }
        }

        /// <summary>
        /// Checks if the reference is valid for the given T. Currently not in use.
        /// </summary>
        /// <param name="reference">The target</param>
        /// <returns>true if reference implements T or has a component which implements T</returns>
        public static bool IsValid(UnityEngine.Object reference)
        {
            if (reference is GameObject gameObject
                && gameObject.TryGetComponent(out T target))
                reference = target as UnityEngine.Object;

            return !reference || reference is T;
        }
    }
}