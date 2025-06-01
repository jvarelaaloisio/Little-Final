using UnityEngine;

namespace Core.Providers
{
    public abstract class DataProvider<T> : ScriptableObject, IDataProvider<T>
    {
        public virtual T Value { get; set; }
        
        public static implicit operator T(DataProvider<T> provider) => provider.Value;
    }
}
