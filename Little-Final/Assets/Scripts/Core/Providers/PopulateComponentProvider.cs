using UnityEngine;

namespace Core.Providers
{
    public abstract class PopulateComponentProvider<T> : PopulateDataProvider<T> where T : Component
    {
        private T _component;
        private T component => _component ??= GetComponent<T>();
        private void OnEnable() => Populate(component);
        private void OnDisable() => Depopulate(component);
    }
}