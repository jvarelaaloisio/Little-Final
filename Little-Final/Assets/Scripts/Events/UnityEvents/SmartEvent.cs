using System;
using UnityEngine;
using UnityEngine.Events;

namespace Events.UnityEvents
{
    [System.Serializable]
    public class SmartEvent : UnityEvent
    {
        private event Action OnEventInternal;

        public SmartEvent()
        {
            OnEventInternal = RaiseEvent;
        }

        [ContextMenu("Raise Event")]
        private void RaiseEvent()
        {
            base.Invoke();
        }
        
        public static implicit operator Action(SmartEvent original) => original.OnEventInternal;
        public static SmartEvent operator +(SmartEvent original, Action action)
        {
            original.AddListener(action.Invoke);
            return original;
        }
        public static SmartEvent operator -(SmartEvent original, Action action)
        {
            original.RemoveListener(action.Invoke);
            return original;
        }
    }
    [System.Serializable]
    public abstract class SmartEvent<T> : UnityEvent<T>
    {
        private event Action<T> OnEventInternal;

        public SmartEvent()
        {
            OnEventInternal = RaiseEvent;
        }

        [ContextMenu("Raise Event")]
        private void RaiseEvent(T value)
        {
            base.Invoke(value);
        }
        
        public static implicit operator Action<T>(SmartEvent<T> original) => original.OnEventInternal;
        public static SmartEvent<T> operator +(SmartEvent<T> original, Action<T> action)
        {
            original.AddListener(action.Invoke);
            return original;
        }
        public static SmartEvent<T> operator -(SmartEvent<T> original, Action<T> action)
        {
            original.RemoveListener(action.Invoke);
            return original;
        }
    }
}