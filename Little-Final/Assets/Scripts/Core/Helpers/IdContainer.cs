using System;
using UnityEngine;

namespace Core.Helpers
{
	[CreateAssetMenu(menuName = "Models/ID", fileName = "Id", order = 0)]
	public class IdContainer : ScriptableObject, IIdentification
	{
		[SerializeField]
		private new string name;

		public Data Get => new Data(name, GetInstanceID());

		public string Name => name;

		/// <inheritdoc />
		public int Id => Get.Id;

		public override string ToString() => name;

		/// <inheritdoc />
		public override bool Equals(object obj)
			=> obj is IIdentification otherId && Equals(otherId);

		/// <inheritdoc />
		public bool Equals(IIdentification other)
			=> Get.Equals(other);

		/// <inheritdoc />
		//THOUGHT: Is this correct? I'm not entirely sure.
		public override int GetHashCode()
			=> GetInstanceID();

		public static bool operator ==(IdContainer original, IdContainer other)
			=> original?.Equals(other) ?? false;

		public static bool operator !=(IdContainer original, IdContainer other)
			=> !original?.Equals(other) ?? true;

		public static implicit operator Data(IdContainer original)
		{
			return original.Get;
		}

		[Serializable]
		public readonly struct Data : IIdentification
		{
			public string name { get; }
			public int Id { get; }

			public Data(string name, int hashCode)
			{
				this.name = name;
				this.Id = hashCode;
			}

			public bool Equals(IIdentification other)
				=> Id == other?.Id;

			public override string ToString()
				=> name;
		}
	}
}