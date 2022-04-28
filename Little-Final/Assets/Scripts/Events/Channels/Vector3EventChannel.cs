using UnityEngine;
using UnityEngine.Events;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Data Channels/Vector3", fileName = "Vector3Channel")]
	public class Vector3EventChannel : EventChannel<Vector3> { }
}