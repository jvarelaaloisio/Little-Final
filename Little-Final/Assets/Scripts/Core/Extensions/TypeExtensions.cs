using System;
using System.Linq;

namespace Core.Extensions
{
	public static class TypeExtensions
	{
		public static string GetFormattedGenericName(this Type type)
		{
			var result = type.Name;

			if (!type.IsGenericType)
				return result;

			var backtickIndex = result.IndexOf('`');
			if (backtickIndex > 0)
				result = result[..backtickIndex];

			var genericArgs = string.Join(", ", type.GetGenericArguments().Select(genericArg => genericArg.Name));
			return $"{result}<{genericArgs}>";

		}
	}
}
