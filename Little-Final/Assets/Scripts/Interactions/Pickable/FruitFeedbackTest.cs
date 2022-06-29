using System;
using System.Collections;
using UnityEngine;

namespace Interactions.Pickable
{
	public class FruitFeedbackTest : MonoBehaviour
	{
		[SerializeField]
		private float[] scales = new float[5];

		[SerializeField]
		private FruitMeshData[] fruitMeshData;
		
		[SerializeField]
		private float scaleDuration;

		[SerializeField]
		private AnimationCurve scaling = AnimationCurve.EaseInOut(0, 0, 1, 1);

		[SerializeField]
		private MeshFilter meshFilter;

		[SerializeField]
		private MeshRenderer meshRenderer;

		private void OnValidate()
		{
			if (!meshFilter) TryGetComponent(out meshFilter);
			if (!meshRenderer) TryGetComponent(out meshRenderer);
		}

		public void UpdateScale(int pos)
		{
			Keyframe[] scalingKeys = scaling.keys;
			float duration = scalingKeys[scalingKeys.Length - 1].time - scalingKeys[0].time;
			pos = Mathf.Clamp(0, pos, scales.Length - 1);
			meshFilter.mesh = fruitMeshData[pos].Mesh;
			meshRenderer.sharedMaterial = fruitMeshData[pos].Material;
			// StartCoroutine(TransitionScale(transform.localScale, Vector3.one * scales[pos], duration));
		}

		private IEnumerator TransitionScale(Vector3 from, Vector3 to, float duration)
		{
			float start = Time.time;
			float current;
			while ((current = Time.time) < start + duration)
			{
				float lerp = (current - start) / duration;
				float smoothLerp = scaling.Evaluate(lerp);
				transform.localScale = Vector3.Lerp(from, to, smoothLerp);
				yield return null;
			}
		}
		[Serializable]
		private struct FruitMeshData
		{
			[SerializeField]
			private Mesh mesh;

			[SerializeField]
			private Material material;
			
			public Mesh Mesh => mesh;

			public Material Material => material;
		}
	}
}