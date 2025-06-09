using System;
using UnityEngine;

namespace Core.Helpers
{
	[CreateAssetMenu(menuName = "Models/ID", fileName = "Id", order = 0)]
	public class IdContainer : ScriptableObject, IIdentification
	{
		[SerializeField]
		private new string name;

		public Data Get => new Data(name, GetHashCode());

		public string Name => name;

		/// <inheritdoc />
		public bool Equals(IIdentification other) => Get.Equals(other);

		/// <inheritdoc />
		public int HashCode => Get.HashCode;

		public override string ToString() => name;

		public static bool operator ==(IdContainer original, IdContainer other)
			=> EqualityInternal(original, other);

		public static bool operator !=(IdContainer original, IdContainer other)
			=> !EqualityInternal(original, other);

		private static bool EqualityInternal(IdContainer original, IdContainer other)
		{
			bool noneIsNull = original && other;
			bool areEqual = original.Get.HashCode == other.Get.HashCode;
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
			public int HashCode { get; }

			public Data(string name, int hashCode)
			{
				this.name = name;
				this.HashCode = hashCode;
			}

			public bool Equals(IIdentification other)
				=> HashCode == other?.HashCode;

			public override string ToString()
				=> name;
		}
	}
}