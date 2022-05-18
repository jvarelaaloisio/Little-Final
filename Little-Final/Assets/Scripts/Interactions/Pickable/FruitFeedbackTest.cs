using System.Collections;
using UnityEngine;

namespace Interactions.Pickable
{
	public class FruitFeedbackTest : MonoBehaviour
	{
		[SerializeField]
		private float[] scales = new float[5];

		[SerializeField]
		private float scaleDuration;
		
		[SerializeField]
		private float resetDuration;

		private Vector3 _originalScale;

		private void Awake()
		{
			_originalScale = transform.localScale;
		}
		
		public void UpdateScale(int pos)
		{
			pos = Mathf.Clamp(0, pos, scales.Length - 1);
			StartCoroutine(TransitionScale(transform.localScale, Vector3.one * scales[pos], scaleDuration));
		}

		public void ResetScale()
		{
			StartCoroutine(TransitionScale(transform.localScale, _originalScale, resetDuration));
		}

		private IEnumerator TransitionScale(Vector3 from, Vector3 to, float duration)
		{
			float start = Time.time;
			float current;
			while ((current = Time.time) < start + duration)
			{
				transform.localScale = Vector3.Lerp(from, to, (current - start) / duration);
				yield return null;
			}
		}
	}
}