using Core.Providers;
using UnityEngine;

namespace DataProviders
{
    public class PopulateAnimatorProvider : MonoBehaviour
    {
        [SerializeField] private Animator animator;
        [SerializeField] private DataProvider<Animator> provider;

        private void OnValidate()
        {
            animator ??= GetComponent<Animator>();
        }

        private void OnEnable()
        {
            provider.TrySetValue(animator);
        }

        private void OnDisable()
        {
            if (provider.TryGetValue(out var value)
                && value == animator)
            {
                provider.Value = null;
            }
        }
    }
}