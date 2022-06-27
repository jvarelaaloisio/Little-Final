using System;
using UnityEngine;
using UnityEngine.Events;

namespace Events.UnityEvents
{
	[System.Serializable]
	public class TransformUnityEvent : UnityEvent<Transform> {
		public static TransformUnityEvent operator +(TransformUnityEvent original, Action<Transform> action)
		{
			original.AddListener(action.Invoke);
			return original;
		}
		public static TransformUnityEvent operator -(TransformUnityEvent original, Action<Transform> action)
		{
			original.RemoveListener(action.Invoke);
			return original;
		} }
}