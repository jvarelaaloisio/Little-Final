using System.Threading;
using Core.Providers;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace DataProviders.Async
{
	public abstract class DataProviderAsync<T> : ScriptableObject, IDataProviderAsync<T>
	{
		public virtual T Value { get; set; }

		public virtual async UniTask<T> GetValueAsync(CancellationToken cancellationToken)
		{
			await UniTask.WaitWhile(() => Value == null, cancellationToken: cancellationToken);
			return Value;
		}
        
		public static implicit operator T(DataProviderAsync<T> provider) => provider.Value;
	}
}