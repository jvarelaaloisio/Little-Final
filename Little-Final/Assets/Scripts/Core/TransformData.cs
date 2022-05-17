using System;
using UnityEngine;

namespace Core
{
	[Serializable]
	public struct TransformData
	{
		[SerializeField]
		public Vector3 position;

		[SerializeField]
		private Vector3 rotation;

		[SerializeField]
		public Vector3 scale;

		public TransformData(Transform baseTransform)
		{
			if (!baseTransform)
			{
				position = Vector3.zero;
				rotation = Vector3.zero;
				scale = Vector3.zero;
				return;
			}

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

		#region ==

		public static bool operator ==(TransformData original, TransformData other)
			=> original.EqualsInternal(other);

		public static bool operator ==(TransformData original, Transform other)
			=> original.EqualsInternal(other);

		#endregion

		#region !=

		public static bool operator !=(TransformData original, TransformData other)
			=> !original.EqualsInternal(other);

		public static bool operator !=(TransformData original, Transform other)
			=> !original.EqualsInternal(other);

		#endregion

		#region Equals

		public override bool Equals(object obj)
		{
			if (obj is TransformData otherData && EqualsInternal(otherData))
				return true;
			return (obj is Transform otherTransform && EqualsInternal(otherTransform));
		}

		private bool EqualsInternal(TransformData other)
		{
			return Vector3.Distance(position, other.position) < .0001f
					&& Vector3.Distance(rotation, other.rotation) < .0001f
					&& Vector3.Distance(scale, other.scale) < .0001f;
		}

		private bool EqualsInternal(Transform other)
		{
			return other
					&& Vector3.Distance(position, other.position) < .0001f
					&& Vector3.Distance(rotation, other.rotation.eulerAngles) < .0001f
					&& Vector3.Distance(scale, other.localScale) < .0001f;
		}

		#endregion

		public static implicit operator TransformData(Transform origin) => new TransformData(origin);

		public override string ToString() => $"position: {position}\trotation: {rotation}\tscale: {scale}";
	}
}