using Core.Extensions;
using UnityEngine;

namespace Core.Providers
{
    public class PopulateDataProvider<T> : MonoBehaviour
    {
        [SerializeField] private DataProvider<T> provider;
        protected void Populate(T value)
        {
            if (!provider)
            {
                this.LogWarning($"{nameof(provider)} is null! this component won't have any effect.");
                return;
            }
            if (value == null)
            {
                this.LogWarning($"{nameof(value)} is null! this component won't have any effect.");
                return;
            }

            if (!provider.Value?.Equals(value) ?? true)
                provider.Value = value;
        }
        
        protected void Depopulate(T value)
        {
            if (provider && (provider.Value?.Equals(value) ?? false))
                provider.Value = default;
        }
    }
}
