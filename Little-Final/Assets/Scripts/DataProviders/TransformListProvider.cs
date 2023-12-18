using System.Collections.Generic;
using Core.Providers;
using UnityEngine;

namespace DataProviders
{
    [CreateAssetMenu(menuName = "_TransformListProvider")]
    public class TransformListProvider : DataProvider<List<Transform>>
    {
        public override List<Transform> Value { get; set; } = new();
    }
}
