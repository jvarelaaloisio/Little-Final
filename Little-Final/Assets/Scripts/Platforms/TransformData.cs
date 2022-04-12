using System;
using UnityEngine;

namespace Platforms
{
	[Serializable]
	public struct TransformData
	{
		[SerializeField] public Vector3 position;
		[SerializeField] private Vector3 rotation;
		[SerializeField] public Vector3 scale;

		public TransformData(Transform baseTransform)
		{
			position = baseTransform.localPosition;
			rotation = baseTransform.rotation.eulerAngles;
			scale = baseTransform.localScale;
		}
		public Quaternion Rotation
		{
			get => Quaternion.Euler(rotation);
			set => rotation = value.eulerAngles;
		}

		public void ApplyDataTo(Transform transform)
		{
			transform.localPosition = position;
			transform.rotation = Rotation;
			transform.localScale = scale;
		}

		public override string ToString() => $"position: {position}\trotation: {rotation}\tscale: {scale}";
	}
}