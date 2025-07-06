using System.Threading;
using Core.Providers;
using Cysharp.Threading.Tasks;

namespace DataProviders.Async
{
	public interface IDataProviderAsync<T> : IDataProvider<T>
	{
		UniTask<T> GetValueAsync(CancellationToken cancellationToken);
	}
}