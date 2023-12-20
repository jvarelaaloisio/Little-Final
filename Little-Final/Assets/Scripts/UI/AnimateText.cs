using System;
using System.Collections;
using Core.Extensions;
using TMPro;
using UnityEngine;

namespace UI
{
    public class AnimateText : MonoBehaviour
    {
        [SerializeField] private float period = 1f;
        [SerializeField] private TMP_Text text;
        [SerializeField] private string[] values;

        private void Reset() => text = GetComponent<TMP_Text>();

        private void OnEnable() => StartCoroutine(Animate());

        private void OnDisable() => StopCoroutine(Animate());

        private IEnumerator Animate()
        {
            var waitPeriod = new WaitForSeconds(period);
            var index = 0;
            if (values.Length < 1)
            {
                this.LogWarning($"{nameof(values)} is empty!");
                yield break;
            }
            while (!destroyCancellationToken.IsCancellationRequested)
            {
                text.text = values[index];
                var nextIndex = index + 1;
                var isAtEnd = index >= values.Length - 1;
                index = isAtEnd ? 0 : nextIndex;
                yield return waitPeriod;
            }
        }
    }
}