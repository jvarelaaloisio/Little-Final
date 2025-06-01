using Core.Extensions;
using Core.References;
using UnityEngine;

namespace Core.Providers
{
    public class PopulateDataProvider<T> : MonoBehaviour
    {
        [SerializeField] private InterfaceRef<IDataProvider<T>> provider;
        protected void Populate(T value)
        {
            if (provider.Ref == null)
            {
                this.LogWarning($"{nameof(provider)} is null! this component won't have any effect.");
                return;
            }
            if (value == null)
            {
                this.LogWarning($"{nameof(value)} is null! this component won't have any effect.");
                return;
            }

            if (!provider.Ref.Value?.Equals(value) ?? true)
                provider.Ref.Value = value;
        }
        
        protected void Depopulate(T value)
        {
            if (provider.Ref?.Value?.Equals(value) ?? false)
                provider.Ref.Value = default;
        }
    }
}
