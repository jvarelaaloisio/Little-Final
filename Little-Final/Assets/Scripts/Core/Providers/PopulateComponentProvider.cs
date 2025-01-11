namespace Core.Providers
{
    public abstract class PopulateComponentProvider<T> : PopulateDataProvider<T>
    {
        private T _component;
        // ReSharper disable once InconsistentNaming
        private T component => _component ??= GetComponent<T>();
        private void OnEnable() => Populate(component);
        private void OnDisable() => Depopulate(component);
    }
}