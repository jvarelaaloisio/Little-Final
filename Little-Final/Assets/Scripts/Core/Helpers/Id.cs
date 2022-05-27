using UnityEngine;

namespace Core.Helpers
{
	[CreateAssetMenu(menuName = "Models/ID", fileName = "Id", order = 0)]
	public class Id : ScriptableObject
	{
		[SerializeField]
		private string name;
		
		public int Identification => GetHashCode();

		public string Name => name;
		public override string ToString() => name;
	}
}