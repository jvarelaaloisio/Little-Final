using UnityEngine;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Data Channels/Float", fileName = "FloatDataChannel")]
	public class FloatEventChannel : EventChannel<float> { }
}