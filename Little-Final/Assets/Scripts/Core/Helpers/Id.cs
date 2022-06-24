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
		public static bool operator ==(Id original, Id other)
			=> EqualityInternal(original, other);

		public static bool operator !=(Id original, Id other)
			=> !EqualityInternal(original, other);
		
		private static bool EqualityInternal(Id original, Id other)
		{
			bool noneIsNull = original && other;
			bool areEqual = original.Identification == other.Identification;
			return noneIsNull && areEqual;
		}
	}
}