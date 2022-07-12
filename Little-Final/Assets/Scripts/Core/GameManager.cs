using UnityEngine;

namespace Core
{
	[CreateAssetMenu(menuName = "Data/GameManager", fileName = "GameManager", order = 0)]
	public class GameManager : ScriptableObject
	{
		public Transform Player { get; set; }
	}
}