using UnityEngine;

namespace Core.Providers
{
    public static class DataProviderHelper
    {
        public static bool TrySetValue<T>(this DataProvider<T> dataProvider, T value) where T : Object
        {
            if (dataProvider == null)
            {
                return false;
            }

            dataProvider.Value = value;
            return true;
        }
    }
}