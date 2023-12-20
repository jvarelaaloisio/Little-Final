using UnityEngine;

namespace Core.Providers
{
    public abstract class DataProvider<T> : ScriptableObject
    {
        public abstract T Value { get; set; }
        
        public static implicit operator T(DataProvider<T> provider) => provider.Value;
    }
}
