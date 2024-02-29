using System;
using UnityEngine;

namespace Interactions.Pickable
{
	public class FruitFeedback : MonoBehaviour
	{
		[SerializeField]
		private FruitMeshData[] fruitMeshData;

		[SerializeField]
		private MeshFilter meshFilter;

		[SerializeField]
		private MeshRenderer meshRenderer;

		private void OnValidate()
		{
			if (!meshFilter) TryGetComponent(out meshFilter);
			if (!meshRenderer) TryGetComponent(out meshRenderer);
		}

		public void UpdateMesh(int pos)
		{
			pos = Mathf.Clamp(0, pos, fruitMeshData.Length - 1);
			meshFilter.mesh = fruitMeshData[pos].Mesh;
			meshRenderer.sharedMaterial = fruitMeshData[pos].Material;
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