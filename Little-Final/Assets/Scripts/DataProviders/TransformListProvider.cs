using System;
using System.Collections.Generic;
using Core.Providers;
using UnityEngine;

namespace DataProviders
{
    [CreateAssetMenu(menuName = "Data/Providers/Transform List")]
    public class TransformListProvider : DataProvider<List<Transform>>
    {
        private void Awake()
        {
            Value = new();
        }
    }
}
