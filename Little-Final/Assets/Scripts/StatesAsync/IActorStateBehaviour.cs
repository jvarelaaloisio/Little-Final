using System.Threading;
using Core.Acting;
using Cysharp.Threading.Tasks;

namespace User.States
{
	public interface IActorStateBehaviour<T>
	{
		UniTask Enter(IActor<T> actor, CancellationToken token);
		UniTask Exit(IActor<T> actor, CancellationToken token);
		UniTask<bool> TryHandleInput(IActor<T> actor, CancellationToken token);
	}
}