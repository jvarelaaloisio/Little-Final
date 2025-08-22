using System;
using Core.Data;
using Core.Extensions;
using Core.Providers;
using Core.References;
using Core.Utils;
using UnityEngine;

namespace Processors
{
	[CreateAssetMenu(menuName = "Data/Processors/Camera Direction", fileName = "CameraDirectionProcessor", order = 0)]
	public class CameraDirectionProcessor : ScriptableObject, IProcessor<Vector3>
	{
		[SerializeField] private InterfaceRef<IDataProvider<Camera>> cameraProvider;

		[Header("Settings")]
		[SerializeField] private bool throwExceptionWhenNoCamera;
		[SerializeField] private bool enableLog;

		/// <inheritdoc />
		public Vector3 Process(Vector3 input)
		{
			if (!cameraProvider.HasValue)
			{
				if (throwExceptionWhenNoCamera)
					throw new ArgumentNullException($"{nameof(cameraProvider)} is null");
				if (enableLog)
					this.LogError($"{nameof(cameraProvider)} is null");
				return Vector3.zero;
			}

			if (!cameraProvider.Ref.TryGetValue(out var camera))
			{
				if (throwExceptionWhenNoCamera)
					throw new ArgumentNullException($"{nameof(cameraProvider)} has no camera");
				if (enableLog)
					this.LogError($"{nameof(cameraProvider)} has no camera");
				return Vector3.zero;
			}
			var direction = camera.transform.TransformDirection(input).IgnoreY();
			return direction;
		}
	}
}