using System.Threading;
using Core.Gameplay;
using Core.Providers;
using Core.References;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using UnityEngine;

namespace VarelaAloisio
{
	public class CameraProviderTest : MonoBehaviour, IDataProviderAsync<Camera>
	{
		[SerializeField] private InterfaceRef<IDataProvider<IInputReader>> _type;
		/// <inheritdoc />
		public Camera Value { get; set; }

		/// <inheritdoc />
		public UniTask<Camera> GetValueAsync(CancellationToken cancellationToken)
		{
			throw new System.NotImplementedException();
		}
	}
}