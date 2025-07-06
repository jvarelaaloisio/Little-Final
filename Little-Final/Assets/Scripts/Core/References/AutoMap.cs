using System;

namespace Core.References
{
	public class AutoMap<T>
	{
		private T _value;
		private readonly Func<T> _get;

		public AutoMap(Func<T> get) => _get = get;

		public T Value => _value ??= _get();
		public static implicit operator T(AutoMap<T> original) => original.Value;
	}
}