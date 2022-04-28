using UnityEngine;

namespace Events.Channels
{
	[CreateAssetMenu(menuName = "Event Channels/Data Channels/GameObject", fileName = "GameObjectDataChannel")]
	public class GameObjectEventChannel : EventChannel<GameObject> { }
}