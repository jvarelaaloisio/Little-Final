using System;
using System.Collections.Generic;
using System.Linq;
using Core.Helpers;
using UnityEngine;

namespace Core.Extensions
{
	public static class NestedDictionaryExtensions
	{
		public static bool TryGetFirst<T>(this IDictionary<Type, IDictionary<IIdentification, object>> data, out T value)
		{
			if (!data.TryGetValue(typeof(T), out var dictionary))
			{
				Debug.LogError($"Couldn't find nested dictionary for Type {typeof(T).Name}!");
				value = default;
				return false;
			}
			var firstValue = dictionary.Values.FirstOrDefault();
			if (firstValue is not T result)
			{
				Debug.LogError($"Couldn't find {typeof(T).Name} in data!");
				value = default;
				return false;
			}

			value = result;
			return true;
		}

		public static bool TryGet<T>(this IDictionary<Type, IDictionary<IIdentification, object>> data,
		                             IIdentification id,
		                             out T value)
		{
			if (!data.TryGetValue(typeof(T), out var actors))
			{
				Debug.LogError($"Couldn't find nested dictionary!");
				value = default;
				return false;
			}
			if (!actors.TryGetValue(id, out var candidate)
			    || candidate is not T result)
			{
				Debug.LogError($"Couldn't find {id.name} in data!");
				value = default;
				return false;
			}

			value = result;
			return true;
		}
	}
}