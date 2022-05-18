using UnityEngine;

namespace Events.Debugging
{
	public class DebugUnityEvent : MonoBehaviour
	{
		public void DebugEvent()
		{
			Debug.Log($"{name}: Unity Event was fired");
		}
		public void DebugEvent(object obj)
		{
			Debug.Log($"{name}: {obj}");
		}
	}
}
