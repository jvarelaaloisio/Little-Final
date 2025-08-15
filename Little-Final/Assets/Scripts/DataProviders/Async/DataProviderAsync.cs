using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace DataProviders.Async
{
	public abstract class DataProviderAsync<T> : ScriptableObject, IDataProviderAsync<T>
	{
		private T _value;

		public virtual T Value
		{
			get => _value;
			set => _value = value;
		}

		public virtual async UniTask<T> GetValueAsync(CancellationToken cancellationToken)
		{
			await UniTask.WaitWhile(() => _value is null, cancellationToken: cancellationToken);
			return Value;
		}
        
		public static implicit operator T(DataProviderAsync<T> provider) => provider.Value;
	}
}