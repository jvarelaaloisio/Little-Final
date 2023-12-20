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

        private void OnEnable()
        {
            if (transformListDataProvider && !transformListDataProvider.Value.Contains(transform))
                transformListDataProvider.Value.Add(transform);
            else
                this.LogWarning($"{nameof(transformListDataProvider)} is null! this component won't have any effect.");
        }

        private void OnDisable()
        {
            if (transformListDataProvider)
            {
                transformListDataProvider.Value.Remove(transform);
            }
        }
    }
}