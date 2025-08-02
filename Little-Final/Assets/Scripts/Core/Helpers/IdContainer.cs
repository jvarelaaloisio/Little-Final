using UnityEngine;

namespace Core.Helpers
{
	[CreateAssetMenu(menuName = "Models/ID", fileName = "Id", order = 0)]
	public class IdContainer : ScriptableObject, IIdentifier
	{
		[SerializeField]
		private new string name;

		public Id Get => new Id(name, GetInstanceID());

		public string Name => name;

		/// <inheritdoc />
		public int Code => Get.Code;

		public override string ToString() => name;

		/// <inheritdoc />
		public override bool Equals(object obj)
			=> obj is IIdentifier otherId && Equals(otherId);

		/// <inheritdoc />
		public bool Equals(IIdentifier other)
			=> Get.Equals(other);

		/// <inheritdoc />
		//THOUGHT: Is this correct? I'm not entirely sure.
		public override int GetHashCode()
			=> GetInstanceID();

		public static bool operator ==(IdContainer original, IdContainer other)
			=> original?.Equals(other) ?? false;

		public static bool operator !=(IdContainer original, IdContainer other)
			=> !original?.Equals(other) ?? true;

		public static implicit operator Id(IdContainer original)
		{
			return original.Get;
		}
	}
}