using UnityEngine;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Data Channels/Bool", fileName = "BoolChannel")]
	public class BoolEventChannel : EventChannel<bool> { }
}