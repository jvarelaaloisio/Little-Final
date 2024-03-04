using System;
using UnityEngine;

namespace Core.Helpers
{
	[CreateAssetMenu(menuName = "Models/ID", fileName = "Id", order = 0)]
	public class IdContainer : ScriptableObject
	{
		[SerializeField]
		private new string name;

		public Data Get => new Data(name, GetHashCode());

		public string Name => name;
		public override string ToString() => name;
		public static bool operator ==(IdContainer original, IdContainer other)
			=> EqualityInternal(original, other);

		public static bool operator !=(IdContainer original, IdContainer other)
			=> !EqualityInternal(original, other);
		
		private static bool EqualityInternal(IdContainer original, IdContainer other)
		{
			bool noneIsNull = original && other;
			bool areEqual = original.Get.hashCode == other.Get.hashCode;
			return noneIsNull && areEqual;
		}

		public static implicit operator Data(IdContainer original)
		{
			return original.Get;
		}
		
		[Serializable]
		public readonly struct Data : IIdentification
		{
			public string name { get; }
			public int hashCode { get; }

			public Data(string name, int hashCode)
			{
				this.name = name;
				this.hashCode = hashCode;
			}
		}
	}
}