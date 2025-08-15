using System;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Extensions;
using Core.References;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using TMPro;
using UnityEngine;

namespace Debugging.Acting
{
	public class RuntimeCharacterDebugger : MonoBehaviour
	{
		[SerializeField] private InterfaceRef<IDataProviderAsync<ICharacter>> characterProvider;
		[SerializeField] private TMP_Text text;
		private CancellationTokenSource _enableToken;
		private ICharacter _character;

		private async void OnEnable()
		{
			try
			{
				_enableToken = new CancellationTokenSource();
				var linkedSource = CancellationTokenSource.CreateLinkedTokenSource(destroyCancellationToken,
				                                                                   _enableToken.Token);
				_character = await characterProvider.Ref.GetValueAsync(linkedSource.Token);
				var indexStoreProperty = new AsyncReactiveProperty<IActor>(_character.Actor);
				indexStoreProperty.BindTo(text);
				_character.FallingController.OnStopFalling += HandleStopFalling;
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
			if (_character is { FallingController: not null })
				_character.FallingController.OnStopFalling -= HandleStopFalling;
		}

		private void HandleStopFalling()
			=> Debug.DrawRay(_character.transform.position, Vector3.up * 0.25f, Color.red, 5f);
	}
}