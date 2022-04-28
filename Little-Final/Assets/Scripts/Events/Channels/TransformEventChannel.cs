using UnityEngine;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Data Channels/Transform", fileName = "TransformChannel")]
	public class TransformEventChannel : EventChannel<Transform> { }
}