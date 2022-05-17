using UnityEngine;

namespace Interactions.Pickable
{
	public class FruitFeedbackTest : MonoBehaviour
	{
		[SerializeField]
		private Color[] colors = new Color[5];

		[SerializeField]
		private Material material;

		private void Start()
		{
			if (!TryGetComponent(out Renderer renderer))
				return;
			material = new Material(material);
			renderer.material = material;
		}

		public void UpdateColor(int pos)
		{
			pos = Mathf.Clamp(0, pos, colors.Length - 1);

			material.color = colors[pos];
		}

		public void ResetColor()
		{
			material.color = colors[colors.Length - 1];
		}
	}
}