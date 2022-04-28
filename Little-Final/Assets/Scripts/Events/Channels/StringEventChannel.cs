using UnityEngine;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Data Channels/String", fileName = "StringChannel")]
	public class StringEventChannel : EventChannel<string> { }
}