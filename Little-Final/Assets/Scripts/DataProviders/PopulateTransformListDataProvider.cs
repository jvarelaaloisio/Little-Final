using System;
using System.Collections.Generic;
using Core.Extensions;
using Core.Providers;
using UnityEngine;

namespace DataProviders
{
    public class PopulateTransformListDataProvider : MonoBehaviour
    {
        [SerializeField] private DataProvider<List<Transform>> transformListDataProvider;

        private void Awake()
        {
            if (transformListDataProvider)
                transformListDataProvider.Value.Add(transform);
            else
                this.LogWarning($"{nameof(transformListDataProvider)} is null! this component won't have any effect.");
        }
    }
}