using System;

namespace Extras
{
	[Serializable]
	public readonly struct FloatParameter
	{
		public readonly string Name;
		public readonly float Value;

		public FloatParameter(string name, float value)
		{
			Name = name;
			Value = value;
		}
	}
}