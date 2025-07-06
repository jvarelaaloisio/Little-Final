using UnityEngine;

namespace Core.Providers
{
    public static class DataProviderExtensions
    {
        public static bool TryGetValue<T>(this IDataProvider<T> provider, out T value)
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
