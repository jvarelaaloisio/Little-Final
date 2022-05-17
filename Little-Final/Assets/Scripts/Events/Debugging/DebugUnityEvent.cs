using UnityEngine;

namespace Events.Debugging
{
	public class DebugUnityEvent : MonoBehaviour
	{
		public void DebugEvent(object obj)
		{
			Debug.Log(obj);
		}
	}
}
