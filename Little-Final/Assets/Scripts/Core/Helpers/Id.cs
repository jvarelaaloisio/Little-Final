using System;

namespace Core.Helpers
{
	[Serializable]
	public readonly struct Id : IIdentifier
	{
		public string name { get; }
		public int Code { get; }

		public Id(string name, int hashCode)
		{
			this.name = name;
			this.Code = hashCode;
		}

		public bool Equals(IIdentifier other)
			=> Code == other?.Code;

		public override string ToString()
			=> name;
	}
}