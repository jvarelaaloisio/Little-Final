using System;
using System.Threading;
using Core.References;
using DataProviders.Async;
using UnityEngine;

namespace UI
{
	public class AssignCameraToCanvasAsync : MonoBehaviour
	{
		[SerializeField] private Canvas canvas;
		[SerializeField] private InterfaceRef<IDataProviderAsync<Camera>> cameraProvider;
		private CancellationTokenSource _enableToken;

		private void Reset()
		{
			canvas = GetComponent<Canvas>();
		}

		private async void OnEnable()
		{
			try
			{
				_enableToken = new CancellationTokenSource();
				var linkedSource = CancellationTokenSource.CreateLinkedTokenSource(destroyCancellationToken,
				                                                                   _enableToken.Token);
				var camera = await cameraProvider.Ref.GetValueAsync(linkedSource.Token);
				canvas.worldCamera = camera;
			}
			catch (OperationCanceledException) {
				Debug.LogWarning($"{nameof(RuntimeAnimatorController)}: Character was never provided during enable.");
				return;
			}
			catch (Exception e)
			{
				Debug.LogException(e, this);
			}
		}

		private void OnDisable()
		{
			_enableToken?.Cancel();
			_enableToken?.Dispose();
			_enableToken = null;
		}
	}
}