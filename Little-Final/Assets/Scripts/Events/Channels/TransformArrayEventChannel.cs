using Events.UnityEvents;
using UnityEngine;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Data Channels/Transform[]", fileName = "TransformArrayChannel")]
	public class TransformArrayEventChannel : EventChannel<Transform[]> { }
}