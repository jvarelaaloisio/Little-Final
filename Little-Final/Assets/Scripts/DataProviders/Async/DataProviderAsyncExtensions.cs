using UnityEngine;

namespace DataProviders.Async
{
	public static class DataProviderAsyncExtensions
	{
		public static bool TryGetValue<T>(this IDataProviderAsync<T> provider, out T value)
		{
			value = default;
			if (provider == null)
			{
				Debug.LogError($"{nameof(provider)} is null!");
				return false;
			}

			value = provider.Value;
			return provider.Value != null;
		}
	}
}